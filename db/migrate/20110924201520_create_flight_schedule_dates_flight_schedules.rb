class CreateFlightScheduleDatesFlightSchedules < ActiveRecord::Migration
  def self.up
    create_table :flight_schedule_dates_flight_schedules, :id => false do |t|
      t.references :flight_schedule
      t.references :flight_schedule_date
    end
  end

  def self.down
    drop_table :flight_schedule_dates_flight_schedules
  end
end
