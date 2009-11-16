class UiLink < SsbeModel
  service_type :kernel
  resource_name :AllUiLinks

  persists :category, :title, :target, :id

  def self.[](title)
    self.detect { |l| l.title == title }
  end
end
