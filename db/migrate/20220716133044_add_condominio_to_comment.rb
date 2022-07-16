class AddCondominioToComment < ActiveRecord::Migration[6.1]
  def change
    add_reference :comments, :condominio, index: true
    add_foreign_key :comments, :condominios
  end
end
