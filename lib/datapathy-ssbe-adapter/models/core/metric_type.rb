
class MetricType < SsbeModel

  service_type :measurements
  resource_name :AllMetricTypes

  persists :name, :path, :stereotype, :metrics_href

  def metrics
    Metric.from(:metrics_href)
  end
end
