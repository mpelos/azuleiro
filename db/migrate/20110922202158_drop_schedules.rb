class DropSchedules < ActiveRecord::Migration
  def self.up
    drop_table :schedules
  end

  def self.down
    create_table "schedules" do |t|
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
end
