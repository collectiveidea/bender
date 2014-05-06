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

ActiveRecord::Schema.define(version: 20140410005101) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "beer_taps", force: true do |t|
    t.string   "name"
    t.integer  "gpio_pin"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "temperature_sensor_id"
    t.decimal  "ml_per_tick",           precision: 6, scale: 5
    t.integer  "kegerator_id"
  end

  create_table "kegerators", force: true do |t|
    t.string   "name"
    t.integer  "temperature_sensor_id"
    t.integer  "min_temp"
    t.integer  "max_temp"
    t.integer  "control_pin"
    t.datetime "last_shutdown"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "alarm_temp"
  end

  create_table "kegs", force: true do |t|
    t.integer  "beer_tap_id"
    t.string   "name"
    t.text     "description"
    t.boolean  "active"
    t.integer  "capacity"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string   "brewery"
    t.string   "style"
    t.decimal  "abv"
  end

  add_index "kegs", ["beer_tap_id"], name: "index_kegs_on_beer_tap_id", using: :btree

  create_table "pours", force: true do |t|
    t.integer  "keg_id"
    t.integer  "sensor_ticks"
    t.decimal  "volume",       precision: 6, scale: 2
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "user_id",                              default: 0, null: false
    t.float    "duration"
  end

  add_index "pours", ["keg_id"], name: "index_pours_on_keg_id", using: :btree

  create_table "temperature_readings", force: true do |t|
    t.integer  "temperature_sensor_id"
    t.decimal  "temp_c",                precision: 6, scale: 3
    t.datetime "created_at"
    t.decimal  "temp_f",                precision: 6, scale: 3
  end

  add_index "temperature_readings", ["temperature_sensor_id", "created_at"], name: "index_temperature_readings_by_date", using: :btree
  add_index "temperature_readings", ["temperature_sensor_id"], name: "index_temperature_readings_on_temperature_sensor_id", using: :btree

  create_table "temperature_sensors", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
  end

end
