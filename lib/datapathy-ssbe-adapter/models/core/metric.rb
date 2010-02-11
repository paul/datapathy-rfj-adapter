
class Metric < SsbeModel

  service_type :measurements

  persists :subject_href, :path, :metric_type_href, :active, :status, :value, :observations_href, :matching_filters_href

end
