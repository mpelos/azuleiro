class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.string   :origin
      t.string   :destination
      t.datetime :depart_at
      t.datetime :return_at
      t.integer  :adults,       :default => 1
      t.integer  :children,     :default => 0
      t.float    :maximum_price
      t.string   :email

      t.timestamps
    end
  end

  def self.down
    drop_table :schedules
  end
end
