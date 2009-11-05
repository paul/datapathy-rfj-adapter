
class Address < SsbeModel
  service_type :kernel
  resource_name :AllAddresses

  persists :name, :identifier, :delivery_method, :account_href

  def account
    Account.at(account_href)
  end

  def account=(account)
    self.account_href = account.href
  end


end
