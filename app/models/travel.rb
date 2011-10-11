class Travel < ActiveRecord::Base
  extend DateTimeAccessors

  belongs_to              :origin,      :class_name => "City", :foreign_key => "origin_id"
  belongs_to              :destination, :class_name => "City", :foreign_key => "destination_id"
  has_and_belongs_to_many :flights

  after_save        :find_or_create_flights

  validates_presence_of :origin, :destination, :adults, :children, :maximum_price, :recipients

  default_scope order("start_depart_datetime", "end_return_datetime")

  split_date_and_time :start_depart_datetime, :end_depart_datetime, :start_return_datetime, :end_return_datetime

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

  def lower_depart_price
    price_modifier * depart_schedules.first.price.value if depart_schedules.any?
  end

  def lower_return_price
    price_modifier * return_schedules.first.price.value if return_schedules.any?
  end

  def lower_total_price
    if lower_depart_price.present? && lower_return_price.present?
      lower_depart_price + lower_return_price
    end
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
      Schedule.find_by_sql "SELECT `schedules`.* FROM `schedules` INNER JOIN `prices` ON `schedules`.`id` = `prices`.`schedule_id` INNER JOIN `flights` ON `schedules`.`flight_id` = `flights`.`id` INNER JOIN `flights_travels` ON `flights`.`id` = `flights_travels`.`flight_id` INNER JOIN `travels` ON `travels`.`id` =  `flights_travels`.`travel_id` WHERE `travels`.`id` = #{id} AND `flights`.`origin_id` = #{origin_id} AND `flights`.`destination_id` = #{destination_id} AND `schedules`.`datetime` >= '#{Time.current}' AND `prices`.`value` <> 0 ORDER BY `prices`.`value`"
    end

    def price_modifier
      adults + (children * 0.6)
    end
end
