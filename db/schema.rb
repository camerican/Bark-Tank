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

ActiveRecord::Schema.define(version: 20170311180955) do

  create_table "project_members", force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.integer "status"
  end

  create_table "project_ratings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.text     "feedback"
    t.decimal  "allocation", precision: 8, scale: 2
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string  "name"
    t.text    "description"
    t.string  "short"
    t.text    "logo"
    t.string  "url"
    t.string  "git"
    t.integer "order"
    t.integer "status"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name_first"
    t.string   "name_last"
    t.string   "slack_name"
    t.text     "photo"
    t.string   "slack_id"
    t.string   "slack_token"
    t.decimal  "funds_remaining", precision: 8, scale: 2
    t.integer  "status"
    t.integer  "role"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

end
