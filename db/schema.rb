# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131224072301) do

  create_table "contacts", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "email"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "region"
    t.string   "postal_code"
    t.string   "cell_phone"
    t.string   "home_phone"
    t.integer  "max_guests"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "facebook_uid"
    t.string   "household_name"
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "occasion_id"
    t.date     "start_date"
    t.string   "start_time"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "region"
    t.string   "postal_code"
    t.string   "location"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["slug"], name: "index_events_on_slug", unique: true

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "invitations", force: true do |t|
    t.integer  "contact_id"
    t.integer  "event_id"
    t.integer  "num_guests"
    t.string   "message"
    t.string   "response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rsvp_id"
  end

  create_table "occasions", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "description"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "occasions", ["slug"], name: "index_occasions_on_slug", unique: true

  create_table "response_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rsvps", force: true do |t|
    t.integer  "occasion_id"
    t.integer  "contact_id"
    t.boolean  "has_responded"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: true do |t|
    t.string   "name"
    t.string   "abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "titles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
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
    t.string   "username"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "region"
    t.string   "postal_code"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.string   "spouse_title"
    t.string   "spouse_first_name"
    t.string   "spouse_last_name"
    t.string   "cell_phone"
    t.string   "home_phone"
    t.integer  "max_guests"
    t.boolean  "share_info"
    t.string   "facebook_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "facebook_token"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
