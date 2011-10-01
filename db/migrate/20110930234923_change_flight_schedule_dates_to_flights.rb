class ChangeFlightScheduleDatesToFlights < ActiveRecord::Migration
  def self.up
    drop_table :flight_schedule_dates

    create_table :flights do |t|
      t.integer    :origin_id
      t.integer    :destination_id
      t.date       :date
      t.timestamps
    end

    add_index "flights", ["origin_id", "destination_id", "date"], :name => "index_on_origin_id_and_destination_id_and_date"
  end

  def self.down
    drop_table :flights

    create_table "flight_schedule_dates", :force => true do |t|
      t.integer  "origin_id"
      t.integer  "destination_id"
      t.date     "date"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "flight_schedule_dates", ["origin_id", "destination_id", "date"], :name => "index_on_origin_id_and_destination_id_and_date"
  end
end
