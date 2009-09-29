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

end
