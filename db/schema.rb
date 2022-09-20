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

ActiveRecord::Schema.define(version: 2022_09_20_213327) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "availabilities_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "availability_id", null: false
    t.index ["availability_id", "user_id"], name: "index_availabilities_users_on_availability_id_and_user_id"
    t.index ["user_id", "availability_id"], name: "index_availabilities_users_on_user_id_and_availability_id"
  end

  create_table "checklists", force: :cascade do |t|
    t.string "cid"
    t.string "name"
    t.integer "resolved"
    t.integer "unresolved"
    t.bigint "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_checklists_on_task_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "cid"
    t.string "name"
    t.boolean "resolved"
    t.bigint "checklist_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checklist_id"], name: "index_items_on_checklist_id"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string "cid"
    t.string "name"
    t.bigint "space_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["space_id"], name: "index_lists_on_space_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.string "vendor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "property_settings", force: :cascade do |t|
    t.string "company"
    t.string "key_name"
    t.string "value_text"
    t.boolean "enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spaces", force: :cascade do |t|
    t.string "cid"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "cid"
    t.string "name"
    t.text "description"
    t.string "parent"
    t.string "url"
    t.integer "status"
    t.boolean "archived"
    t.datetime "due_date"
    t.datetime "date_created"
    t.datetime "date_closed"
    t.bigint "list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority"
    t.index ["list_id"], name: "index_tasks_on_list_id"
  end

  create_table "tasks_users", id: false, force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "user_id", null: false
    t.index ["task_id", "user_id"], name: "index_tasks_users_on_task_id_and_user_id"
    t.index ["user_id", "task_id"], name: "index_tasks_users_on_user_id_and_task_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "cid"
    t.string "gid"
    t.string "username"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "last_status"
  end

  add_foreign_key "checklists", "tasks"
  add_foreign_key "items", "checklists"
  add_foreign_key "items", "users"
  add_foreign_key "lists", "spaces"
  add_foreign_key "tasks", "lists"
end
