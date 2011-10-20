class AddRoleAndActiveToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :role,   :integer, :default => Role::TRAVELLER
    add_column :users, :active, :boolean, :default => false
  end

  def self.down
    remove_column :users, :active
    remove_column :users, :role
  end
end
