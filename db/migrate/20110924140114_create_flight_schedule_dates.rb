class CreateFlightScheduleDates < ActiveRecord::Migration
  def self.up
    create_table :flight_schedule_dates do |t|
      t.integer :origin_id
      t.integer :destination_id
      t.date :date

      t.timestamps
    end

    add_index :flight_schedule_dates, ["origin_id", "destination_id", "date"], :name => "index_on_origin_id_and_destination_id_and_date"
  end

  def self.down
    drop_table :flight_schedule_dates
  end
end
