class CreateCondominios < ActiveRecord::Migration[6.1]
  def change
    create_table :condominios do |t|
      t.string :condo_id
      t.string :nome_cond
      t.string :comune_condo
      t.string :coord_condo
      t.string :via_condo
      t.references :fk_utenti_condo_id, null: false, foreign_key: true
      t.references :fk_superutenti_condo_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
