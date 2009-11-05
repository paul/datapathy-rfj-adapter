
class Privilege < SsbeModel

 service_type :kernel
 resource_name :AllPrivileges

 persists :name, :roles_having_privilege_href

 def self.[](name)
   self.detect { |p| p.name == name.to_s } || raise( "Record not found: #{name}")
 end

end
