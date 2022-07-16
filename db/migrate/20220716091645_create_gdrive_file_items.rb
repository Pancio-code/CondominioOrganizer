class CreateGdriveFileItems < ActiveRecord::Migration[6.1]
  def change
    create_table :gdrive_file_items do |t|
      t.string :file_id
      t.references :gdrive_user_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
