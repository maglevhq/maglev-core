# frozen_string_literal: true

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

ActiveRecord::Schema[8.1].define(version: 20_251_116_171_603) do
  create_table 'accounts', charset: 'utf8mb4', collation: 'utf8mb4_unicode_ci', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.string 'email'
    t.string 'password_digest'
    t.datetime 'updated_at', null: false
  end

  create_table 'active_storage_attachments', charset: 'utf8mb4', collation: 'utf8mb4_unicode_ci', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', precision: nil, null: false
    t.string 'name', null: false
    t.bigint 'record_id', null: false
    t.string 'record_type', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', charset: 'utf8mb4', collation: 'utf8mb4_unicode_ci', force: :cascade do |t|
    t.bigint 'byte_size', null: false
    t.string 'checksum', null: false
    t.string 'content_type'
    t.datetime 'created_at', precision: nil, null: false
    t.string 'filename', null: false
    t.string 'key', null: false
    t.text 'metadata'
    t.string 'service_name', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', charset: 'utf8mb4', collation: 'utf8mb4_unicode_ci',
                                                 force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'maglev_assets', charset: 'utf8mb4', collation: 'utf8mb4_unicode_ci', force: :cascade do |t|
    t.integer 'byte_size'
    t.string 'content_type'
    t.datetime 'created_at', null: false
    t.string 'filename'
    t.integer 'height'
    t.datetime 'updated_at', null: false
    t.integer 'width'
  end

  create_table 'maglev_page_paths', charset: 'utf8mb4', collation: 'utf8mb4_unicode_ci', force: :cascade do |t|
    t.boolean 'canonical', default: true
    t.string 'locale', null: false
    t.bigint 'maglev_page_id'
    t.string 'value', null: false
    t.index %w[canonical locale value], name: 'canonical_speed'
    t.index %w[canonical maglev_page_id locale], name: 'scoped_canonical_speed'
    t.index ['maglev_page_id'], name: 'index_maglev_page_paths_on_maglev_page_id'
  end

  create_table 'maglev_pages', charset: 'utf8mb4', collation: 'utf8mb4_unicode_ci', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.integer 'lock_version'
    t.json 'meta_description_translations'
    t.json 'og_description_translations'
    t.json 'og_image_url_translations'
    t.json 'og_title_translations'
    t.datetime 'published_at', precision: nil
    t.json 'sections_translations'
    t.json 'seo_title_translations'
    t.json 'title_translations'
    t.datetime 'updated_at', null: false
    t.boolean 'visible', default: true
  end

  create_table 'maglev_sections_content_stores', charset: 'utf8mb4', collation: 'utf8mb4_unicode_ci',
                                                 force: :cascade do |t|
    t.string 'container_id'
    t.string 'container_type'
    t.datetime 'created_at', null: false
    t.boolean 'published', default: false
    t.json 'sections_translations'
    t.datetime 'updated_at', null: false
    t.index %w[container_id container_type published],
            name: 'maglev_sections_content_stores_container_and_published', unique: true
  end

  create_table 'maglev_sites', charset: 'utf8mb4', collation: 'utf8mb4_unicode_ci', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.json 'locales'
    t.integer 'lock_version'
    t.string 'name'
    t.datetime 'published_at', precision: nil
    t.json 'sections_translations'
    t.json 'style'
    t.datetime 'updated_at', null: false
  end

  create_table 'products', charset: 'utf8mb4', collation: 'utf8mb4_unicode_ci', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.string 'name'
    t.float 'price'
    t.string 'sku'
    t.boolean 'sold_out', default: false
    t.datetime 'updated_at', null: false
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
end
