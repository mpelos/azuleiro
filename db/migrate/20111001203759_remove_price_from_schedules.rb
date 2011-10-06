class RemovePriceFromSchedules < ActiveRecord::Migration
  def self.up
    remove_column :schedules, :price
  end

  def self.down
    add_column :schedules, :price, :float
  end
end
