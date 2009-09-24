
class SsbeModel
  include Datapathy::Model

  persists :_type, :href, :id, :created_at, :updated_at

  def initialize(attributes = {})
    super
    self._type = self.class.to_s
  end

  def self.service_type(service_type = nil)
    if service_type
      @service_type = service_type
    else
      @service_type
    end
  end

  def self.resource_name(resource_name = nil)
    if resource_name
      @resource_name = resource_name
    else
      @resource_name
    end
  end

  # Get a single resource from a known location
  def self.at(href)
    self.detect { |m|
      m.href == href
    }
  end

  # Get a collection from a location other than the default
  def self.from(href)
    query = SsbeConsole::SsbeQuery.new(model)
    query.location = href
    Datapathy::Collection.new(query)
  end

  def self.key
    :href
  end

end

module SsbeConsole
  class SsbeQuery < Datapathy::Query
    def location
      @location
    end
    def location=(href)
      @location = href
    end
  end
end
