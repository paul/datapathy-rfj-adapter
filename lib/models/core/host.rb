
class Host < SsbeModel

  service_type :measurements

  persists :name, :active?, :tags, :client_href, :metrics_href

  def metrics
    Metric.from(metrics_href)
  end

end
