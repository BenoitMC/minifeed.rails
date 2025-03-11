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

ActiveRecord::Schema[8.0].define(version: 2025_03_10_144627) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gin"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"

  create_table "categories", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "name"
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "entries", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "feed_id"
    t.string "external_id"
    t.string "name"
    t.text "body"
    t.string "url"
    t.string "author"
    t.datetime "published_at", precision: nil
    t.boolean "is_read", default: false, null: false
    t.boolean "is_starred", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name_for_search"
    t.text "keywords_for_search"
    t.index ["user_id", "external_id"], name: "index_entries_on_user_id_and_external_id"
    t.index ["user_id", "feed_id", "is_read", "published_at"], name: "idx_on_user_id_feed_id_is_read_published_at_936cb244b9"
    t.index ["user_id", "feed_id", "published_at"], name: "index_entries_on_user_id_and_feed_id_and_published_at"
    t.index ["user_id", "is_read", "published_at"], name: "index_entries_on_user_id_and_is_read_and_published_at"
    t.index ["user_id", "is_starred", "published_at"], name: "index_entries_on_user_id_and_is_starred_and_published_at"
    t.index ["user_id", "keywords_for_search"], name: "index_entries_on_keywords_for_search", opclass: { keywords_for_search: :gin_trgm_ops }, using: :gin
    t.index ["user_id", "name_for_search"], name: "index_entries_on_name_for_search", opclass: { name_for_search: :gin_trgm_ops }, using: :gin
    t.index ["user_id", "published_at"], name: "index_entries_on_user_id_and_published_at"
  end

  create_table "feeds", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "category_id"
    t.string "name"
    t.string "url"
    t.datetime "last_import_at", precision: nil
    t.integer "import_errors", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "blacklist"
    t.text "whitelist"
    t.string "user_agent"
    t.index ["category_id"], name: "index_feeds_on_category_id"
    t.index ["user_id"], name: "index_feeds_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "password_digest", default: "", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "auth_token"
    t.boolean "is_admin", default: false, null: false
    t.string "name"
    t.string "theme"
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end
end
