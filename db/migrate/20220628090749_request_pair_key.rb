class RequestPairKey < ActiveRecord::Migration[6.1]
  def change
    add_index :requests, [:condominio_id, :user_id], unique: true
  end
end
