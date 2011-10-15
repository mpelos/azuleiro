class Schedule < ActiveRecord::Base
  belongs_to :flight
  has_one    :price, :dependent => :destroy

  default_scope order("flight_id", "datetime")

  def to_s
    datetime
  end
end
