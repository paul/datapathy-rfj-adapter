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
      http_resource = http_resource_for(query)

      collection.each do |resource|
        record = serialize(resource)
        content_type = content_type_for(resource)

        begin
          response = http_resource.post(record, "Content-Type" => content_type)
          resource.key = response.header['Location']
          resource.merge!(deserialize(response)) unless response.body.blank?
        rescue Resourceful::UnsuccessfulHttpRequestError => e
          if e.http_response.code == 403
            set_errors(resource, e)
          else
            raise e
          end
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

    def update(attributes, collection)
      collection.each do |resource|
        content = serialize(resource, attributes)
        content_type = content_type_for(resource)

        begin
          response = http.resource(resource.href, default_headers).put(content, "Content-Type" => content_type)
          resource.merge!(deserialize(response)) unless response.body.blank?
        rescue Resourceful::UnsuccessfulHttpRequestError => e
          if e.http_response.code == 403
            set_errors(resource, e)
          else
            raise e
          end
        end
      end
    end

    def services_uri
      @services_uri ||= "http://core.#{backend}/service_descriptors"
    end

    protected

    def deserialize(response)
      JSON.parse(response.body.gsub('\/', '/')).symbolize_keys
    end

    def serialize(resource, attrs_for_update = {})
      attrs = resource.persisted_attributes.dup.merge(attrs_for_update)
      attrs.delete_if { |k,v| v.nil? }
      JSON.fast_generate(attrs)
    end

    def http_resource_for(query)
      model = query.model

      url = if query.respond_to?(:location) && location = query.location
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

    def content_type_for(resource)
      ServiceDescriptor::ServiceIdentifiers[resource.model.service_type].mime_type
    end

    def set_errors(resource, exception)
      errors =  deserialize(exception.http_response)[:errors]
      errors.each do |field, messages|
        resource.errors[field].push *messages
      end
    end


    def default_headers
      @default_headers ||= {
        :accept => 'application/vnd.absperf.sskj1+json, application/vnd.absperf.ssmj1+json, application/vnd.absperf.ssej1+json, application/vnd.absperf.sscj1+json'
      }
    end

  end

end

