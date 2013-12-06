module FakeUser
  module UserPatch
    def self.included(base)
      base.send :include, InstanceMethods

      base.class_eval do
        unloadable
        safe_attributes 'allow_fake_login'
      end
    end

    module InstanceMethods
    end
  end
end

User.send(:include, FakeUser::UserPatch)
