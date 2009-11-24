
class MetricFilter < SsbeModel
  service_type  :measurements
  resource_name :AllMetricFilters

  persists :purpose, :any_or_all, :criteria, :client_href, :metrics_href

  def client=(client)
    @client_href = client.href
  end

  def client
    @client ||= Client.at(@client_href) if @client_href
  end

  def criteria
    @criteria || []
  end

  def self.targets
    targets = JSON.parse(targets_json).with_indifferent_access[:items]
  end

  def self.targets_json
    url = ServiceDescriptor[:measurements].resource_for("AllMetricFilterTargets").href
    response = Datapathy.default_adapter.http.resource(url).get(:accept => ServiceDescriptor::ServiceIdentifiers[:measurements].mime_type)
    response.body
  end
end
