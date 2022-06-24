class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.integer :condominio_id
      t.integer :user_id

      t.timestamps
    end
  end
end
