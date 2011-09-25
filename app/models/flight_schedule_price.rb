class FlightSchedulePrice < ActiveRecord::Base
  belongs_to :flight_schedule_date

  default_scope order("flight_schedule_date_id", "datetime", "price")

  def to_s
    price
  end
end
