class AddCurrentPriceToFlightSchedules < ActiveRecord::Migration
  def self.up
    add_column :flight_schedules, :current_price, :float
  end

  def self.down
    remove_column :flight_schedules, :current_price
  end
end
