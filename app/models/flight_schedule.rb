# encoding: UTF-8

class FlightSchedule < ActiveRecord::Base
  require "capybara"

  include EnumerateIt

  DEPARTURE_TAX = 16.23

  belongs_to              :origin,      :class_name => "City", :foreign_key => "origin_id"
  belongs_to              :destination, :class_name => "City", :foreign_key => "destination_id"
  has_and_belongs_to_many :flight_schedule_dates

  validates_presence_of :origin, :destination, :adults, :children, :maximum_price, :recipients

  after_save :find_or_create_flight_schedule_dates

  default_scope order("start_depart_datetime", "end_return_datetime")


  def depart_flights_schedule_dates
    flight_schedule_dates.where(:origin_id => origin.id, :destination_id => destination.id)
  end

  def return_flights_schedule_dates
    flight_schedule_dates.where(:origin_id => destination.id, :destination_id => origin.id)
  end

  def depart_flight_schedule_prices
    depart_flights_schedule_dates.collect { |fsd| fsd.flight_schedule_prices }.flatten.sort_by { |fsp| fsp.price }.delete_if { |fsp| fsp.datetime < Time.current }
  end

  def return_flight_schedule_prices
    return_flights_schedule_dates.collect { |fsd| fsd.flight_schedule_prices }.flatten.sort_by { |fsp| fsp.price }.delete_if { |fsp| fsp.datetime < Time.current }
  end

  def lower_total_price
    modifier = adults * (children > 0 ? children * 0.6 : 1)
    ((depart_flight_schedule_prices.first.price + return_flight_schedule_prices.first.price) * modifier) + (2 * DEPARTURE_TAX)
  end

  protected
    def find_or_create_flight_schedule_dates
      self.flight_schedule_dates = []
      depart_range = start_depart_datetime.to_date..end_depart_datetime.to_date
      return_range = start_return_datetime.to_date..end_return_datetime.to_date

      depart_range.each do |date|
        flight_schedule_dates.find_or_create_by_origin_id_and_destination_id_and_date(origin_id, destination_id, date)
      end

      return_range.each do |date|
        flight_schedule_dates.find_or_create_by_origin_id_and_destination_id_and_date(destination_id, origin_id, date)
      end
    end
end
