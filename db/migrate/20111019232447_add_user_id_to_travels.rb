class AddUserIdToTravels < ActiveRecord::Migration
  def self.up
    add_column :travels, :user_id, :integer
  end

  def self.down
    remove_column :travels, :user_id
  end
end
