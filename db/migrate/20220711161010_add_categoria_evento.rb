class AddCategoriaEvento < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :categoria, :string,null: false
  end
end
