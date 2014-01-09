module FakeUser
  module AccountControllerPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method_chain :logout, :fake
      end
    end

    module InstanceMethods
      def fake
        redirect_to home_url unless User.current.admin? || User.current.allow_fake_login

        if request.get?
          @users = User.where(:status => 1)
        else
          user = User.where(:login => params[:username]).first

          if user

            unless cookies[:initial]
              cookie_options = {
                  :value => Digest::MD5.hexdigest(User.current.login),
                  :expires => 1.year.from_now,
                  :path => '/',
                  :secure => false,
                  :httponly => true
              }
              cookies[:initial] = cookie_options
            end

            logout_user
            successful_authentication(user)
          else
            redirect_to home_url
          end
        end
      end

      def logout_with_fake

        if User.current.anonymous?
          redirect_to home_url
        elsif request.post?
          logout_user

          if cookies[:initial]
            user = User.where("MD5(login) = '#{cookies[:initial]}'").first

            if user
              cookies.delete :initial
              successful_authentication(user)
            else
              redirect_to home_url
            end

          else
            redirect_to home_url
          end
        end
      end
    end
  end
end

AccountController.send(:include, FakeUser::AccountControllerPatch)