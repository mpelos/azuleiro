class Schedule < ActiveRecord::Base
  belongs_to :flight

  default_scope order("flight_id", "datetime", "price")

  def to_s
    price
  end
end
