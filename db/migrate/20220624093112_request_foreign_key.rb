class RequestForeignKey < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :requests, :condominios
    add_foreign_key :requests, :users
  end
end
