
module AccessControl

  def self.included(model)
    model.send(:include, InstanceMethods)

    model.extend(ClassMethods)
    #model.extend(ActiveRecordFinders) if model.superclass == ActiveRecord::Base
    ActiveRecord::Relation.send(:include, VisibleToRelation)
  end

  module InstanceMethods

    def visible_to?(account)
      account.has_privilege_at?(self.class.view_privilege, respond_to?(:client_href) ? client_href : client)
    end

    def modifiable_by?(account)
      account.has_privilege_at?(self.class.modify_privilege, respond_to?(:client_href) ? client_href : client)
    end

    def creatable_by?(account)
      account.has_privilege_at?(self.class.create_privilege, respond_to?(:client_href) ? client_href : client)
    end

  end

  module ClassMethods

    def creatable_by?(account)
      account.has_privilege_at_any_client?(create_privilege)
    end

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

  module VisibleToRelation

    def visible_to(account)
      all.select { |r| r.visible_to?(account) }
    end

  end

  module ActiveRecordFinders

    def find_every_with_visible_to(options)
      account = options.delete(:visible_to) if options.has_key?(:visible_to)
      records = find_every_without_visible_to(options)
      records = records.select { |r| r.visible_to?(account) } if account
      records
    end

    module ActiveRecord::SpawnMethods
      VALID_FIND_OPTIONS << :visible_to
    end

    #ActiveRecord::Calculations::CALCULATIONS_OPTIONS << :visible_to

    def self.extended(ar)
      (class << ar; self; end).alias_method_chain :find_every, :visible_to
    end
  end
end
