class ChangeEmailFromSchedules < ActiveRecord::Migration
  def self.up
    change_table :schedules do |t|
      t.remove :email
      t.string :recipients
    end
  end

  def self.down
    change_table :schedules do |t|
      t.remove :recipients
      t.string :email
    end
  end
end
