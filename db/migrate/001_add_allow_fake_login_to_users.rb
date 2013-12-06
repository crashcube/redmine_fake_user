class AddAllowFakeLoginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :allow_fake_login, :boolean, :default => false, :null => false
  end
end
