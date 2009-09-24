require 'ostruct'

class ServiceDescriptor < SsbeModel

  persists :service_type

  def self.[](name)
    service_type = IDENTIFIERS.detect { |i| i.name.to_s == name.to_s }.service_type
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
    resources.detect { |r| r.name == resource_name }
  end

  protected

  def identifier
    @identifier ||= IDENTIFIERS.detect { |i| i.service_type == service_type }
  end

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
