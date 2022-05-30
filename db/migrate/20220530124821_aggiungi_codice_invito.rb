class AggiungiCodiceInvito < ActiveRecord::Migration[6.1]
  def change
  	add_column :condominios, :flat_code, :string
  end
end
