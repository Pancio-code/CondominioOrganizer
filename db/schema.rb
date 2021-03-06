# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_07_16_091645) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.integer "post_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "condominio_id"
    t.index ["condominio_id"], name: "index_comments_on_condominio_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "condominios", force: :cascade do |t|
    t.string "nome"
    t.string "comune"
    t.string "indirizzo"
    t.float "latitude"
    t.float "longitude"
    t.string "codice"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "flat_code"
  end

  create_table "condominos", force: :cascade do |t|
    t.integer "condominio_id"
    t.integer "user_id"
    t.boolean "is_condo_admin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "permission_id"
    t.string "folder_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "titolo"
    t.datetime "start_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "condominio_id"
    t.string "categoria", null: false
    t.string "calendar_id"
    t.index ["condominio_id"], name: "index_events_on_condominio_id"
  end

  create_table "gdrive_condo_items", force: :cascade do |t|
    t.string "folder_id"
    t.integer "condominio_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["condominio_id"], name: "index_gdrive_condo_items_on_condominio_id"
  end

  create_table "gdrive_file_items", force: :cascade do |t|
    t.string "file_id"
    t.integer "gdrive_user_item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gdrive_user_item_id"], name: "index_gdrive_file_items_on_gdrive_user_item_id"
  end

  create_table "gdrive_user_items", force: :cascade do |t|
    t.string "folder_id"
    t.integer "condomino_id", null: false
    t.integer "gdrive_condo_items_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["condomino_id"], name: "index_gdrive_user_items_on_condomino_id"
    t.index ["gdrive_condo_items_id"], name: "index_gdrive_user_items_on_gdrive_condo_items_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "user_id", null: false
    t.integer "condominio_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["condominio_id"], name: "index_posts_on_condominio_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "condominio_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["condominio_id", "user_id"], name: "index_requests_on_condominio_id_and_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uname"
    t.boolean "from_oauth", default: false
    t.boolean "is_admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "condominios"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "events", "condominios"
  add_foreign_key "gdrive_condo_items", "condominios"
  add_foreign_key "gdrive_file_items", "gdrive_user_items"
  add_foreign_key "gdrive_user_items", "condominos"
  add_foreign_key "gdrive_user_items", "gdrive_condo_items", column: "gdrive_condo_items_id"
  add_foreign_key "posts", "condominios"
  add_foreign_key "posts", "users"
  add_foreign_key "requests", "condominios"
  add_foreign_key "requests", "users"
end
