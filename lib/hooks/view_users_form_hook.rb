module FakeUser
  class ViewUsersFormHook < Redmine::Hook::ViewListener
    def view_users_form(context={})
      "<p>#{context[:form].check_box :allow_fake_login}</p>"
    end
  end
end