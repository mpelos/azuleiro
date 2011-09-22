class CreateFlightSchedules < ActiveRecord::Migration
  def self.up
    create_table "flight_schedules" do |t|
      t.string   "origin"
      t.string   "destination"
      t.datetime "depart_at"
      t.datetime "return_at"
      t.integer  "adults",        :default => 1
      t.integer  "children",      :default => 0
      t.float    "maximum_price"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "recipients"
    end
  end

  def self.down
    drop_table :flight_schedules
  end
end
