class AddFkDeleteCascade < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :comments, :condominios
    remove_foreign_key :comments, :posts
    remove_foreign_key :comments, :users
    remove_foreign_key :events, :condominios
    remove_foreign_key :gdrive_condo_items, :condominios
    remove_foreign_key :gdrive_file_items, :gdrive_user_items
    remove_foreign_key :gdrive_user_items, :condominos
    remove_foreign_key :gdrive_user_items, :gdrive_condo_items, column: :gdrive_condo_items_id
    remove_foreign_key :posts, :condominios
    remove_foreign_key :posts, :users
    remove_foreign_key :requests, :condominios
    remove_foreign_key :requests, :users


    add_foreign_key :comments, :condominios, on_delete: :cascade
    add_foreign_key :comments, :posts, on_delete: :cascade
    add_foreign_key :comments, :users, on_delete: :cascade
    add_foreign_key :events, :condominios, on_delete: :cascade
    add_foreign_key :gdrive_condo_items, :condominios, on_delete: :cascade
    add_foreign_key :gdrive_file_items, :gdrive_user_items, on_delete: :cascade
    add_foreign_key :gdrive_user_items, :condominos, on_delete: :cascade
    add_foreign_key :gdrive_user_items, :gdrive_condo_items, column: :gdrive_condo_items_id, on_delete: :cascade
    add_foreign_key :posts, :condominios, on_delete: :cascade
    add_foreign_key :posts, :users, on_delete: :cascade
    add_foreign_key :requests, :condominios, on_delete: :cascade
    add_foreign_key :requests, :users, on_delete: :cascade
  end
end
