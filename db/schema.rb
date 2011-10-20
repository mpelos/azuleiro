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

ActiveRecord::Schema.define(:version => 20111020000019) do

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flights", :force => true do |t|
    t.integer  "origin_id"
    t.integer  "destination_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flights", ["origin_id", "destination_id", "date"], :name => "index_on_origin_id_and_destination_id_and_date"

  create_table "flights_travels", :id => false, :force => true do |t|
    t.integer "travel_id"
    t.integer "flight_id"
  end

  create_table "prices", :force => true do |t|
    t.integer  "flight_id"
    t.integer  "schedule_id"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", :force => true do |t|
    t.integer  "flight_id"
    t.datetime "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "travels", :force => true do |t|
    t.integer  "origin_id"
    t.integer  "destination_id"
    t.datetime "start_depart_datetime"
    t.datetime "end_depart_datetime"
    t.datetime "start_return_datetime"
    t.datetime "end_return_datetime"
    t.integer  "adults",                :default => 1
    t.integer  "children",              :default => 0
    t.float    "maximum_price"
    t.string   "recipients"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                           :null => false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.integer  "role",                         :default => 1
    t.boolean  "active",                       :default => false
  end

  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"

end
