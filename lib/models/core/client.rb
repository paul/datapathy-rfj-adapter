class Client < SsbeModel

  service_type :kernel
  resource_name :AllClients

  persists :name, :longname, :active, :parent_href, :hosts_href

  def self.[](name)
    self.detect { |c| c.name == name }
  end

  #API = self["API"]

  def hosts
    Host.from(hosts_href)
  end

end
