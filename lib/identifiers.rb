
class ServiceIdentifiers

  class << self

    def [](name_or_type)
      IDENTIFIERS.detect { |i| i.name == name_or_type || i.service_type == name_or_type }
    end

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
