class CreateCondominos < ActiveRecord::Migration[6.1]
  def change
    create_table :condominos do |t|

      t.integer :condominio_id
      t.integer :user_id

      t.boolean :is_condo_admin

      t.timestamps
    end
  end
end
