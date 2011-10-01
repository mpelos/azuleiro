class ChangeFlightSchedulePricesToSchedules < ActiveRecord::Migration
  def self.up
    drop_table :flight_schedule_prices

    create_table :schedules do |t|
      t.references :flight
      t.datetime   :datetime
      t.float      :price
      t.timestamps
    end
  end

  def self.down
    drop_table :schedules

    create_table "flight_schedule_prices", :force => true do |t|
      t.integer  "flight_schedule_date_id"
      t.datetime "datetime"
      t.float    "price"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
