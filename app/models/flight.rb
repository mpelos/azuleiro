class Flight < ActiveRecord::Base
  belongs_to              :origin,      :class_name => "City", :foreign_key => "origin_id"
  belongs_to              :destination, :class_name => "City", :foreign_key => "destination_id"
  has_and_belongs_to_many :travels
  has_many                :schedules
  has_many                :prices

  default_scope order("origin_id", "destination_id", "date")
end
