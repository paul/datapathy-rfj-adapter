require 'datapathy'
require 'resourceful'
require 'json'
require 'active_support/core_ext/hash/keys'

$:.unshift(File.expand_path(File.dirname(__FILE__))) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'resourceful/ssbe_authenticator'

require 'datapathy-ssbe-adapter/ssbe_model'

require 'datapathy-ssbe-adapter/models/service_descriptor'
require 'datapathy-ssbe-adapter/models/resource_descriptor'

module Datapathy::Adapters

  class SsbeAdapter < Datapathy::Adapters::AbstractAdapter

    attr_reader :http, :backend

    def initialize(options = {})
      super

      @backend = @options[:backend]
      @username, @password = @options[:username], @options[:password]

      @http = Resourceful::HttpAccessor.new
      @http.logger = @options[:logger] if @options[:logger]
      @http.cache_manager = Resourceful::InMemoryCacheManager.new
      @http.add_authenticator Resourceful::SsbeAuthenticator.new(@username, @password)
    end

    def create(collection)
      query = collection.query

      collection.each do |resource|
        http_resource = http_resource_for(query || resource)
        record = serialize(resource)
        content_type = ServiceDescriptor::ServiceIdentifiers[resource.model.service_type].mime_type

        begin
          response = http_resource.post(record, "Content-Type" => content_type)
          resource.key = response.header['Location']
          resource.merge!(deserialize(response)) unless response.body.blank?
        rescue Resourceful::UnsuccessfulHttpRequestError => e
          # TODO check for invalid record, and populate errors
          #pp JSON.parse(e.http_response.body)
          raise e
        end
      end
    end

    def read(collection)
      query = collection.query
      if query.key_lookup?
        response = http.resource(query.key, default_headers).get
        Array.wrap(deserialize(response))
      else
        response = http_resource_for(query).get
        records = deserialize(response)[:items]
        records.map! { |r| r.symbolize_keys! }
        records
      end
    end

    def services_uri
      @services_uri ||= "http://core.#{backend}/service_descriptors"
    end

    protected

    def deserialize(response)
      JSON.parse(response.body.gsub('\/', '/')).symbolize_keys
    end

    def serialize(resource)
      attrs = resource.persisted_attributes.dup
      attrs.delete_if { |k,v| v.nil? }
      JSON.fast_generate(attrs)
    end

    def http_resource_for(query_or_resource)
      model = query_or_resource.model

      if query_or_resource.is_a?(Datapathy::Query)
        query = query_or_resource
      else
        resource = query_or_resource
      end

      url = if query && query.respond_to?(:location) && location = query.location
              location
            elsif model == ServiceDescriptor
              services_uri
            else
              service_desc = ServiceDescriptor[model.service_type]
              resource_desc = service_desc.resource_for(model.resource_name)
              resource_desc.href
            end

      raise "Could not identify a location to look for #{model}" unless url

      http.resource(url, default_headers)
    end

    def default_headers
      @default_headers ||= {
        :accept => 'application/vnd.absperf.sskj1+json; q=0.8, application/vnd.absperf.ssmj1+json; q=0.8, application/vnd.absperf.ssej1+json; q=0.8, application/vnd.absperf.sscj1+json; q=0.8'
      }
    end

  end

end

