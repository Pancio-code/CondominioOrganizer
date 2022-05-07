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

ActiveRecord::Schema.define(version: 2022_05_07_095931) do

  create_table "condominios", force: :cascade do |t|
    t.string "condo_id"
    t.string "nome_cond"
    t.string "comune_condo"
    t.string "coord_condo"
    t.string "via_condo"
    t.integer "fk_utenti_condo_id", null: false
    t.integer "fk_superutenti_condo_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fk_superutenti_condo_id"], name: "index_condominios_on_fk_superutenti_condo_id"
    t.index ["fk_utenti_condo_id"], name: "index_condominios_on_fk_utenti_condo_id"
  end

  add_foreign_key "condominios", "fk_superutenti_condos"
  add_foreign_key "condominios", "fk_utenti_condos"
end
