require 'resourceful'
require 'json'

require 'ssbe_authenticator'

require 'ssbe_model'

require 'service_descriptor'
require 'resource_descriptor'

module Datapathy::Adapters

  class SsbeAdapter < Datapathy::Adapters::AbstractAdapter
      
    attr_reader :http, :backend

    def initialize(options = {})
      super

      @backend = options[:backend]
      @user, @password = options[:user], options[:password]

      @http = Resourceful::HttpAccessor.new
      @http.logger = Resourceful::StdOutLogger.new if @options[:logging]
      @http.cache_manager = Resourceful::InMemoryCacheManager.new
      @http.add_authenticator Resourceful::SsbeAuthenticator.new(@user, @password)
    end

    def read(query)
      if query.key_lookup?
        response = http.resource(query.key, default_headers).get
        query.filter_records([deserialize(response)])
      else
        response = resource_for(query).get
        records = deserialize(response)['items']
        query.filter_records(records)
      end
    end

    protected 

    def deserialize(response)
      JSON.parse(response.body.gsub('\/', '/'))
    end

    def resource_for(query)
      model = query.model
      url = if query.respond_to?(:location) && location = query.location
              location
            elsif model == ServiceDescriptor
              services_uri
            else
              service_desc = ServiceDescriptor[model.service_type.to_s]
              resource_desc = service_desc.resource_for(model.resource_name.to_s)
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

    def services_uri
      @services_uri ||= "http://core.#{backend}/service_descriptors"
    end

  end

end

