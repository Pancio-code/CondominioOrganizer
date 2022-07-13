class CreateGdrives < ActiveRecord::Migration[6.1]
  def change
    create_table :gdrives do |t|
      t.string :condo_cartella_id
      t.string :cartella_id
      t.references :condomino, null: false, foreign_key: true

      t.timestamps
    end
  end
end
