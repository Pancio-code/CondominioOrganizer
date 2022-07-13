class CreateGdriveUserItems < ActiveRecord::Migration[6.1]
  def change
    create_table :gdrive_user_items do |t|
      t.string :folder_id
      t.references :condomino, null: false, foreign_key: true
      t.references :gdrive_condo_items, null: false, foreign_key: true

      t.timestamps
    end
  end
end
