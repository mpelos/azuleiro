class Flight < ActiveRecord::Base
  belongs_to              :origin,      :class_name => "City", :foreign_key => "origin_id"
  belongs_to              :destination, :class_name => "City", :foreign_key => "destination_id"
  has_many                :schedules
  has_and_belongs_to_many :travels

  default_scope order("origin_id", "destination_id", "date")
end
