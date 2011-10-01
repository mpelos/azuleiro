class ChangeFlightScheduleDatesFlightSchedulesToFlightsTravels < ActiveRecord::Migration
  def self.up
    drop_table :flight_schedule_dates_flight_schedules

    create_table :flights_travels, :id => false do |t|
      t.references :travel
      t.references :flight
    end
  end

  def self.down
    drop_table :flights_travels

    create_table "flight_schedule_dates_flight_schedules", :id => false do |t|
      t.integer "flight_schedule_id"
      t.integer "flight_schedule_date_id"
    end
  end
end
