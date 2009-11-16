
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
end
