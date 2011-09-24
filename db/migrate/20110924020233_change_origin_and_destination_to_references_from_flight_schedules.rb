class ChangeOriginAndDestinationToReferencesFromFlightSchedules < ActiveRecord::Migration
  def self.up
    change_table :flight_schedules do |t|
      t.remove  :origin
      t.remove  :destination
      t.integer :origin_id
      t.integer :destination_id
    end
  end

  def self.down
    change_table :flight_schedules do |t|
      t.remove  :origin_id
      t.remove  :destination_id
      t.integer :origin
      t.integer :destination
    end
  end
end
