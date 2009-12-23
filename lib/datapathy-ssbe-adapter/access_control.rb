
module AccessControl

  def self.included(model)
    model.send(:include, InstanceMethods)

    model.extend(ClassMethods)
  end

  module InstanceMethods

    def visible_to?(account)
      account.has_privilege_at?(self.class.view_privilege, respond_to?(:client_href) ? client_href : client)
    end
    memoize :visible_to?

  end

  module ClassMethods

    def privilege_name
      @privilege_name ||= self.name.underscore
    end

    %w[view create modify].each do |action|
      class_eval <<-RUBY, __FILE__, __LINE__
        def #{action}_privilege_name
          @#{action}_privilege_name ||= "#{action}_\#{privilege_name}"
        end

        def #{action}_privilege
          @#{action}_privilege ||= Privilege[#{action}_privilege_name]
        end
      RUBY
    end

  end

end
