class Client < SsbeModel

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

class Host < SsbeModel
  service_type :kernel

  service_type :measurements

  persists :name, :active, :tags, :client_href, :metrics_href

  def client
    Client.at(client_href)
  end

end
