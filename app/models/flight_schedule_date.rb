class FlightScheduleDate < ActiveRecord::Base
  belongs_to :origin,      :class_name => "City", :foreign_key => "origin_id"
  belongs_to :destination, :class_name => "City", :foreign_key => "destination_id"
end
