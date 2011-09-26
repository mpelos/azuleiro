class RemoveCurrentPricepriceFromFlightSchedules < ActiveRecord::Migration
  def self.up
    remove_column :flight_schedules, :current_price
  end

  def self.down
    add_column :flight_schedules, :current_price, :float
  end
end
