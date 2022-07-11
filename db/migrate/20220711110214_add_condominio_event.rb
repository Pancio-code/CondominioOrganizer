class AddCondominioEvent < ActiveRecord::Migration[6.1]
  def change
    add_reference :events, :condominio, index: true
    add_foreign_key :events, :condominios
  end
end
