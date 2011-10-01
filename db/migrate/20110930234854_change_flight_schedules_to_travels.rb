class ChangeFlightSchedulesToTravels < ActiveRecord::Migration
  def self.up
    drop_table :flight_schedules

    create_table :travels do |t|
      t.integer    :origin_id
      t.integer    :destination_id
      t.datetime   :start_depart_datetime
      t.datetime   :end_depart_datetime
      t.datetime   :start_return_datetime
      t.datetime   :end_return_datetime
      t.integer    :adults,  :default => 1
      t.integer    :children, :default => 0
      t.float      :maximum_price
      t.string     :recipients
      t.timestamps
    end
  end

  def self.down
    drop_table :travels

    create_table :flight_schedules do |t|
      t.integer  "adults",                :default => 1
      t.integer  "children",              :default => 0
      t.float    "maximum_price"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "recipients"
      t.datetime "start_depart_datetime"
      t.datetime "end_depart_datetime"
      t.datetime "start_return_datetime"
      t.datetime "end_return_datetime"
      t.integer  "origin_id"
      t.integer  "destination_id"
    end
  end
end
