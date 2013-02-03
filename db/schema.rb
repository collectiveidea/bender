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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130203212003) do

  create_table "beer_taps", :force => true do |t|
    t.string   "name"
    t.integer  "gpio_pin"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "kegs", :force => true do |t|
    t.integer  "beer_tap_id"
    t.string   "name"
    t.text     "description"
    t.boolean  "active"
    t.integer  "capacity"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.datetime "started_at"
    t.datetime "finished_at"
  end

  add_index "kegs", ["beer_tap_id"], :name => "index_kegs_on_beer_tap_id"

end
