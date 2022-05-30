class UserAdminDefault < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :is_admin, :boolean, :default => "false"
  end
end
