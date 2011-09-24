class AddRangeForDepartAtAndReturnAtToFlightSchedules < ActiveRecord::Migration
  def self.up
    change_table :flight_schedules do |t|
      t.remove   :depart_at
      t.remove   :return_at
      t.datetime :start_depart_datetime
      t.datetime :end_depart_datetime
      t.datetime :start_return_datetime
      t.datetime :end_return_datetime
    end
  end

  def self.down
    change_table :flight_schedules do |t|
      t.remove   :start_depart_datetime
      t.remove   :end_depart_datetime
      t.remove   :start_return_datetime
      t.remove   :end_return_datetime
      t.datetime :depart_at
      t.datetime :return_at
    end
  end
end
