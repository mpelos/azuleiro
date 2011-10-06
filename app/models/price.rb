class Price < ActiveRecord::Base
  belongs_to :flight
  belongs_to :schedule

  def to_s
    value
  end
end
