
class Account < SsbeModel
  service_type :kernel
  resource_name :AllAccounts

  persists :login, :full_name, :time_zone,
           :password,
           :roles_by_client_href,
           :clients_by_role_href,
           :clients_by_privilege_href,
           :privileges_by_client_href,
           :addresses_href,
           :authentication_credentials_href,
           :role_assignments_href,
           :preferred_client_href,
           :initial_client_href,
           :initial_role_href

  def self.find_by_login(login)
    self.detect { |a| a.login == login }
  end

  def md5_auth_credentials
    @md5_auth_credentials ||= 
      Datapathy.default_adapter.http.
        resource(authentication_credentials_href).
        get(:accept => 'application/prs.md5-hexdigest-auth-creds').body
  end

  def has_privilege_at?(privilege, client)
    clients_by_privilege(privilege).include?(client)
  end

  def clients_by_privilege(privilege)
    Client.from(clients_by_privilege_href, :privilege_href => privilege.href)
  end

  def addresses
    Address.from(addresses_href)
  end

end
