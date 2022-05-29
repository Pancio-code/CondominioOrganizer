class CreateCondominios < ActiveRecord::Migration[6.1]
  def change
    create_table :condominios do |t|
      t.string :nome
      t.string :comune
      t.string :indirizzo
      t.float :latitudine
      t.float :longitudine
      t.string :codice

      t.timestamps
    end
  end
end
