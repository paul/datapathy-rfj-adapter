class Client < SsbeModel
  include AccessControl

  service_type :kernel
  resource_name :AllClients

  persists :name, :longname, :active, :parent_href, :hosts_href

  def hosts
    Host.from(hosts_href)
  end

  def client
    self
  end
end
