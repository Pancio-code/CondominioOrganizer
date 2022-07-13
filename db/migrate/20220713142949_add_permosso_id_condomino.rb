class AddPermossoIdCondomino < ActiveRecord::Migration[6.1]
  def change
    add_column :condominos, :permission_id, :string,null: true
  end
end
