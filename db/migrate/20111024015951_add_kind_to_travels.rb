class AddKindToTravels < ActiveRecord::Migration
  def self.up
    add_column :travels, :round_trip, :boolean, :default => 1
  end

  def self.down
    remove_column :travels, :round_trip
  end
end
