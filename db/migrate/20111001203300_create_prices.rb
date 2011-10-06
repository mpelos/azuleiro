class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.references :flight
      t.references :schedule
      t.float      :value

      t.timestamps
    end
  end

  def self.down
    drop_table :prices
  end
end
