class AddFromOauth < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :from_oauth, :boolean, default: false
  end
end
