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

ActiveRecord::Schema.define(version: 2021_11_28_131748) do

  create_table "alcohol_licenses", force: :cascade do |t|
    t.datetime "expires_at"
    t.datetime "reported_at"
    t.integer "business_category_id"
    t.integer "license_category_id"
    t.integer "location_id"
    t.integer "business_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_category_id"], name: "index_alcohol_licenses_on_business_category_id"
    t.index ["business_id"], name: "index_alcohol_licenses_on_business_id"
    t.index ["license_category_id"], name: "index_alcohol_licenses_on_license_category_id"
    t.index ["location_id"], name: "index_alcohol_licenses_on_location_id"
  end

  create_table "business_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "businesses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "license_categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "address_1"
    t.string "address_2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "transformed_location_id"
    t.index ["transformed_location_id"], name: "index_locations_on_transformed_location_id"
  end

  create_table "streets", force: :cascade do |t|
    t.string "trait"
    t.string "name_1"
    t.string "name_2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transformed_locations", force: :cascade do |t|
    t.string "address_1"
    t.string "building_number"
    t.float "latitude"
    t.float "longtitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_1", "building_number"], name: "index_transformed_locations_on_address_1_and_building_number", unique: true
  end

  add_foreign_key "alcohol_licenses", "business_categories"
  add_foreign_key "alcohol_licenses", "businesses"
  add_foreign_key "alcohol_licenses", "license_categories"
  add_foreign_key "alcohol_licenses", "locations"
  add_foreign_key "locations", "transformed_locations"
end
