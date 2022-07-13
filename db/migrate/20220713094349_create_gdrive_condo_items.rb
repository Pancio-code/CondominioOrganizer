class CreateGdriveCondoItems < ActiveRecord::Migration[6.1]
  def change
    create_table :gdrive_condo_items do |t|
      t.string :folder_id
      t.references :condominio, null: false, foreign_key: true

      t.timestamps
    end
  end
end
