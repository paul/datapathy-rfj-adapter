
class Address < SsbeModel
  service_type :kernel
  resource_name :AllAddresses

  persists :name, :identifier, :delivery_method, :account_href

  EMAIL_REGEXP = /[A-Z0-9._%+-]+@[A-Z0-9.-]+/i

  def account
    Account.at(account_href) if account_href
  end

  def account=(account)
    self.account_href = account.href
  end

  def self.by_href(href, reload = nil)
    @cache = nil if reload
    @cache ||= all.to_a.map { |a| [a.href, a] }.inject({}){ |ha, (k,v)| ha[k] = v; ha }

    @cache[href]
  end

  def to_s
    "#{name} <#{identifier}>"
  end

end
