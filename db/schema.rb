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

ActiveRecord::Schema.define(:version => 20110924020233) do

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flight_schedules", :force => true do |t|
    t.integer  "adults",                :default => 1
    t.integer  "children",              :default => 0
    t.float    "maximum_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "recipients"
    t.float    "current_price"
    t.datetime "start_depart_datetime"
    t.datetime "end_depart_datetime"
    t.datetime "start_return_datetime"
    t.datetime "end_return_datetime"
    t.integer  "origin_id"
    t.integer  "destination_id"
  end

end
