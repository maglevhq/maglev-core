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

ActiveRecord::Schema[8.0].define(version: 2022_06_12_092235) do
  create_table "accounts", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "maglev_assets", force: :cascade do |t|
    t.string "filename"
    t.string "content_type"
    t.integer "width"
    t.integer "height"
    t.integer "byte_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "maglev_page_paths", force: :cascade do |t|
    t.bigint "maglev_page_id"
    t.string "locale", null: false
    t.string "value", null: false
    t.boolean "canonical", default: true
    t.index ["canonical", "locale", "value"], name: "canonical_speed"
    t.index ["canonical", "maglev_page_id", "locale"], name: "scoped_canonical_speed"
    t.index ["maglev_page_id"], name: "index_maglev_page_paths_on_maglev_page_id"
  end

  create_table "maglev_pages", force: :cascade do |t|
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "title_translations", default: {}
    t.json "seo_title_translations", default: {}
    t.json "meta_description_translations", default: {}
    t.json "sections_translations", default: {}
    t.integer "lock_version"
    t.json "og_title_translations", default: {}
    t.json "og_description_translations", default: {}
    t.json "og_image_url_translations", default: {}
  end

  create_table "maglev_sites", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "locales", default: []
    t.json "sections_translations", default: {}
    t.integer "lock_version"
    t.json "style", default: []
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "sku"
    t.float "price"
    t.boolean "sold_out", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
