
class ResourceDescriptor < SsbeModel

  persists :name

  def self.[](name)
    self.select { |m|
      m.name == name
    }
  end
end
