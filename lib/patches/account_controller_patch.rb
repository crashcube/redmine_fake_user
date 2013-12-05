module FakeUser
  module AccountControllerPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def fake
        redirect_to home_url unless User.current.admin?

        if request.get?
          @users = User.where(:status => 1)
        else
          user = User.where(:login => params[:username]).first

          if user
            logout_user
            successful_authentication(user)
          else
            redirect_to home_url
          end
        end
      end
    end
  end
end

AccountController.send(:include, FakeUser::AccountControllerPatch)