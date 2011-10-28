class AddingNotNullToFlightOriginDestinationAndDate < ActiveRecord::Migration
  def self.up
    change_table :flights do |t|
      t.change :origin_id, :integer, :null => false
      t.change :destination_id, :integer, :null => false
      t.change :date, :date, :null => false
    end
  end

  def self.down
    change_table :flights do |t|
      t.change :origin_id, :integer, :null => true
      t.change :destination_id, :integer, :null => true
      t.change :date, :date, :null => true
    end
  end
end
