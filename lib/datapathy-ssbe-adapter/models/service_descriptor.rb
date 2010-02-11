class ServiceDescriptor < SsbeModel
  service_type :kernel

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

  def self.register(name, href)
    service_type = ServiceIdentifiers[name].service_type
    create(:service_type => service_type,
           :href         => href)
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
        :name =>          :escdef,
        :service_type =>  "http://systemshepherd.com/services/escdef",
        :mime_type =>     "application/vnd.absperf.ssj1+json"
      ),
      ServiceIdentifier.new(
        :name =>          :issues,
        :service_type =>  "http://systemshepherd.com/services/issues",
        :mime_type =>     "application/vnd.absperf.ssj1+json"
      ),
      ServiceIdentifier.new(
        :name =>          :configurator,
        :service_type =>  "http://systemshepherd.com/services/configurator",
        :mime_type =>     "application/vnd.absperf.sscj1+json"
      )
    ].freeze

  end

end
