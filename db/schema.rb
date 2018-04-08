# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180408230125) do

  create_table "Units", force: :cascade do |t|
    t.integer  "manager_id"
    t.integer  "tenant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id", "tenant_id"], name: "index_relationships_on_manager_id_and_tenant_id", unique: true
    t.index ["manager_id"], name: "index_relationships_on_manager_id"
    t.index ["tenant_id"], name: "index_relationships_on_tenant_id"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "documents", force: :cascade do |t|
    t.string   "document"
    t.integer  "unit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit_id"], name: "index_documents_on_unit_id"
  end

  create_table "plaid_credentials", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "access_token"
    t.string   "item_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["user_id"], name: "index_plaid_credentials_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string   "street_number"
    t.string   "route"
    t.string   "unit"
    t.string   "locality"
    t.string   "administrative_area_level_1"
    t.string   "country"
    t.string   "postal_code"
    t.string   "google_place_id"
    t.string   "zillow_zpid"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "purchases", force: :cascade do |t|
    t.string   "stripe_charge_id"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["stripe_charge_id", "user_id"], name: "index_purchases_on_stripe_charge_id_and_user_id"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "token_data", force: :cascade do |t|
    t.string   "encrypted_access_token"
    t.string   "encrypted_access_token_iv"
    t.integer  "expires_in"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "transfer_customers", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_transfer_customers_on_user_id"
  end

  create_table "transfer_schedules", force: :cascade do |t|
    t.integer  "transfer_term_id"
    t.integer  "transfer_id"
    t.string   "status"
    t.date     "initialize_transfer_date"
    t.integer  "value_cents"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "transfer_attempt_counter"
    t.index ["transfer_id"], name: "index_transfer_schedules_on_transfer_id"
    t.index ["transfer_term_id"], name: "index_transfer_schedules_on_transfer_term_id"
  end

  create_table "transfer_terms", force: :cascade do |t|
    t.integer  "monthly_amount_cents"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "unit_id"
    t.date     "start_date"
    t.date     "end_date"
    t.index ["unit_id"], name: "index_transfer_terms_on_unit_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.string   "link"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "transfer_term_id"
    t.integer  "request_status_code"
    t.string   "transfer_status"
    t.string   "resource_status_link"
    t.integer  "transfer_schedule_id"
    t.index ["link"], name: "index_transfers_on_link"
    t.index ["transfer_schedule_id"], name: "index_transfers_on_transfer_schedule_id"
    t.index ["transfer_term_id"], name: "index_transfers_on_transfer_term_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
