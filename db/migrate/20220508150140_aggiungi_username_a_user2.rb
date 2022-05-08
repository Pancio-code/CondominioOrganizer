class AggiungiUsernameAUser2 < ActiveRecord::Migration[6.1]
  def change
  	add_column :users, :uname, :string
  end
end
