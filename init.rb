Redmine::Plugin.register :redmine_fake_user do
  name 'Redmine Fake User plugin'
  author 'Denis Lysenko'
  description 'This is allow to login as another user'
  version '0.0.1'
  url 'http://zennex.ru'
  author_url 'http://alouds.ru'

  menu :account_menu, :fake_login, { :controller => 'account', :action => 'fake' }, :caption => 'Sign in as', :before => :logout, :if => Proc.new { User.current.admin? || User.current.allow_fake_login }
end

require 'hooks/view_users_form_hook'
require 'patches/account_controller_patch'
require 'patches/user_patch'
