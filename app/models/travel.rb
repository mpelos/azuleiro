# encoding: UTF-8

class Travel < ActiveRecord::Base
  require "capybara"

  DEPARTURE_TAX = 16.23

  belongs_to              :origin,      :class_name => "City", :foreign_key => "origin_id"
  belongs_to              :destination, :class_name => "City", :foreign_key => "destination_id"
  has_and_belongs_to_many :flights

  validates_presence_of :origin, :destination, :adults, :children, :maximum_price, :recipients

  after_save :find_or_create_flights

  default_scope order("start_depart_datetime", "end_return_datetime")


  def depart_flights
    flights.where(:origin_id => origin.id, :destination_id => destination.id)
  end

  def return_flights
    flights.where(:origin_id => destination.id, :destination_id => origin.id)
  end

  def depart_schedules
    find_schedules_by_sql origin.id, destination.id
  end

  def return_schedules
    find_schedules_by_sql destination.id, origin.id
  end

  def lower_total_price
    modifier = adults + (children * 0.6)
    ((depart_schedules.first.price.value + return_schedules.first.price.value) * modifier) + ((adults + children) * 2 * DEPARTURE_TAX)
  end

  protected
    def find_or_create_flights
      self.flights = []
      depart_range = start_depart_datetime.to_date..end_depart_datetime.to_date
      return_range = start_return_datetime.to_date..end_return_datetime.to_date

      depart_range.each do |date|
        flights << Flight.find_or_create_by_origin_id_and_destination_id_and_date(origin_id, destination_id, date)
      end

      return_range.each do |date|
        flights << Flight.find_or_create_by_origin_id_and_destination_id_and_date(destination_id, origin_id, date)
      end
    end

    def find_schedules_by_sql(origin_id, destination_id)
      Schedule.find_by_sql "SELECT `schedules`.* FROM `schedules` INNER JOIN `prices` ON `schedules`.`id` = `prices`.`schedule_id` INNER JOIN `flights` ON `schedules`.`flight_id` = `flights`.`id` INNER JOIN `flights_travels` ON `flights`.`id` = `flights_travels`.`flight_id` INNER JOIN `travels` ON `travels`.`id` =  `flights_travels`.`travel_id` WHERE `travels`.`id` = #{id} AND `flights`.`origin_id` = #{origin_id} AND `flights`.`destination_id` = #{destination_id} AND `schedules`.`datetime` >= '#{Time.current}' ORDER BY `prices`.`value`"
    end
end
