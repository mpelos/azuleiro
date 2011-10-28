class AddingNotNullToCityNameAndCode < ActiveRecord::Migration
  def self.up
    change_table :cities do |t|
      t.change :name, :string, :null => false
      t.change :code, :string, :null => false
    end
  end

  def self.down
    change_table :cities do |t|
      t.change :name, :string, :null => true
      t.change :code, :string, :null => true
    end
  end
end
