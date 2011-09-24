class CreateFlightSchedulePrices < ActiveRecord::Migration
  def self.up
    create_table :flight_schedule_prices do |t|
      t.integer :flight_schedule_date_id
      t.datetime :datetime
      t.float :price

      t.timestamps
    end

    add_index :flight_schedule_prices, ["flight_schedule_date_id", "datetime"], :name => "index_on_flight_schedule_date_id_and_datetime"
  end

  def self.down
    drop_table :flight_schedule_prices
  end
end
