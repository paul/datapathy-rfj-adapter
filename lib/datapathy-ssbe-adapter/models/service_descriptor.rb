class ServiceDescriptor < SsbeModel

  persists :service_type

  def self.[](name)
    service_type = ServiceIdentifiers[name].service_type
    self.detect { |m|
      m.service_type == service_type
    }
  end

  def name
    identifier.name
  end

  def mime_type
    identifier.mime_type
  end

  def resources
    ResourceDescriptor.from(href)
  end

  def resource_for(resource_name)
    resources.detect { |r| r.name == resource_name.to_s }
  end

  protected

  def identifier
    @identifier ||= ServiceIdentifiers[service_type]
  end

  class ServiceIdentifiers

    def self.[](name_or_type)
      IDENTIFIERS.detect { |i| i.name == name_or_type || i.service_type == name_or_type }
    end

    require 'ostruct'
    class ServiceIdentifier < OpenStruct; end

    IDENTIFIERS = [
      ServiceIdentifier.new(
        :name =>          :kernel,
        :service_type =>  "http://systemshepherd.com/services/kernel",
        :mime_type =>     "application/vnd.absperf.sskj1+json"
      ),
      ServiceIdentifier.new(
        :name =>          :measurements,
        :service_type =>  "http://systemshepherd.com/services/measurements",
        :mime_type =>     "application/vnd.absperf.ssmj1+json"
      ),
      ServiceIdentifier.new(
        :name =>          :escalations,
        :service_type =>  "http://systemshepherd.com/services/escalations",
        :mime_type =>     "application/vnd.absperf.ssej1+json"
      ),
      ServiceIdentifier.new(
        :name =>          :configurator,
        :service_type =>  "http://systemshepherd.com/services/configurator",
        :mime_type =>     "application/vnd.absperf.sscj1+json"
      )
    ].freeze

  end

end
