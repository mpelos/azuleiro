class Schedule < ActiveRecord::Base
  belongs_to :flight
  has_one    :price

  default_scope order("flight_id", "datetime")

  def to_s
    datetime
  end
end
