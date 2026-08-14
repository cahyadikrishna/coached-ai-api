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

ActiveRecord::Schema[8.1].define(version: 2026_08_14_084346) do
  create_schema "extensions"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.uuid-ossp"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vault.supabase_vault"

  create_table "public.users", force: :cascade do |t|
    t.string "access_token"
    t.datetime "created_at", null: false
    t.string "refresh_token"
    t.string "strava_id", null: false
    t.integer "token_expires_at"
    t.datetime "updated_at", null: false
    t.index ["strava_id"], name: "index_users_on_strava_id", unique: true
  end

  create_table "public.weekly_summaries", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.date "end_date"
    t.jsonb "metrics", default: {}, null: false
    t.date "start_date"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_weekly_summaries_on_user_id"
  end

  add_foreign_key "public.weekly_summaries", "public.users"

end
