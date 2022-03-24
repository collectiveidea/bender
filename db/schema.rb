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

ActiveRecord::Schema[7.0].define(version: 2017_10_03_222034) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "beer_taps", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "gpio_pin"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "temperature_sensor_id"
    t.decimal "ml_per_tick", precision: 6, scale: 5
    t.integer "kegerator_id"
    t.integer "display_order"
    t.integer "valve_pin"
  end

  create_table "kegerators", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "temperature_sensor_id"
    t.integer "min_temp"
    t.integer "max_temp"
    t.integer "control_pin"
    t.datetime "last_shutdown", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "alarm_temp"
  end

  create_table "kegs", id: :serial, force: :cascade do |t|
    t.integer "beer_tap_id"
    t.string "name"
    t.text "description"
    t.boolean "active"
    t.integer "capacity"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "started_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.string "brewery"
    t.string "style"
    t.decimal "abv"
    t.integer "srm"
    t.index ["beer_tap_id"], name: "index_kegs_on_beer_tap_id"
  end

  create_table "pours", id: :serial, force: :cascade do |t|
    t.integer "keg_id"
    t.integer "sensor_ticks"
    t.decimal "volume", precision: 6, scale: 2
    t.datetime "started_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "user_id", default: 0, null: false
    t.float "duration"
    t.index ["keg_id"], name: "index_pours_on_keg_id"
  end

  create_table "temperature_readings", id: :serial, force: :cascade do |t|
    t.integer "temperature_sensor_id"
    t.decimal "temp_c", precision: 6, scale: 3
    t.datetime "created_at", precision: nil
    t.decimal "temp_f", precision: 6, scale: 3
    t.index ["temperature_sensor_id", "created_at"], name: "index_temperature_readings_by_date"
    t.index ["temperature_sensor_id"], name: "index_temperature_readings_on_temperature_sensor_id"
  end

  create_table "temperature_sensors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "email"
    t.string "rfid"
    t.decimal "credits"
    t.datetime "last_pour_at", precision: nil
  end

end
