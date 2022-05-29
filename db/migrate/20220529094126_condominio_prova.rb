class CondominioProva < ActiveRecord::Migration[6.1]
  def change
    rename_column :condominios, :latitudine, :latitude
    rename_column :condominios, :longitudine, :longitude
  end
end
