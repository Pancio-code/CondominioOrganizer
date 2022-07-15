class AddFolderIdToCondomino < ActiveRecord::Migration[6.1]
  def change
    add_column :condominos, :folder_id, :string
  end
end
