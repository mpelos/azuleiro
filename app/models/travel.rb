# encoding: UTF-8

class Travel < ActiveRecord::Base
  extend DateTimeAccessors

  MAXIMUM_TRAVELS_PER_USER = 3

  belongs_to              :user
  belongs_to              :origin,      :class_name => "City", :foreign_key => "origin_id"
  belongs_to              :destination, :class_name => "City", :foreign_key => "destination_id"
  has_and_belongs_to_many :flights

  before_save :set_null_to_return_datetime, :if => lambda { !round_trip? }
  after_save  :find_or_create_flights

  validates_presence_of :user, :origin, :destination, :adults, :children, :maximum_price, :recipients
  validate              :different_city_for_origin_and_destination,
                        :depart_date_range,
                        :depart_date_in_the_future,
                        :maximum_depart_range

  validate              :return_date_range,
                        :return_date_in_the_future,
                        :depart_date_higher_then_return_date,
                        :maximum_return_range,
                        :if => lambda { round_trip? }

  validate :maximum_travel_length_per_user, :unless => lambda { user.administrator? }

  default_scope     order("start_depart_datetime", "end_return_datetime")
  scope :avaliable, where("end_depart_datetime >= '#{2.hours.from_now.utc.to_formatted_s(:db)}'")

  split_date_and_time :start_depart_datetime, :end_depart_datetime, :start_return_datetime, :end_return_datetime

  def depart_flights
    flights.where(:origin_id => origin.id, :destination_id => destination.id)
  end

  def return_flights
    flights.where(:origin_id => destination.id, :destination_id => origin.id) if round_trip?
  end

  def avaliable_schedules(origin_id, destination_id, minimum_datetime, maximum_datetime)
    Schedule.find_by_sql <<-QUERY
      SELECT
        `schedules`.*
      FROM
        `schedules`
      INNER JOIN
        `prices` ON `schedules`.`id` = `prices`.`schedule_id`
      INNER JOIN
        `flights` ON `schedules`.`flight_id` = `flights`.`id`
      INNER JOIN
        `flights_travels` ON `flights`.`id` = `flights_travels`.`flight_id`
      INNER JOIN
        `travels` ON `travels`.`id` =  `flights_travels`.`travel_id`
      WHERE
        `travels`.`id` = #{id}
        AND `flights`.`origin_id` = #{origin_id}
        AND `flights`.`destination_id` = #{destination_id}
        AND `schedules`.`datetime`
          BETWEEN '#{minimum_datetime.utc.to_formatted_s(:db)}' AND '#{maximum_datetime.utc.to_formatted_s(:db)}'
        AND `schedules`.`datetime` >= '#{2.hours.from_now.utc.to_formatted_s(:db)}'
        AND `prices`.`value` <> 0
      ORDER BY
        `prices`.`value`
    QUERY
  end

  def depart_schedules
    avaliable_schedules origin.id, destination.id, start_depart_datetime, end_depart_datetime
  end

  def return_schedules
    avaliable_schedules destination.id, origin.id, start_return_datetime, end_return_datetime if round_trip?
  end

  def lower_depart_price
    price_modifier * depart_schedules.first.price.value if depart_schedules.any?
  end

  def lower_return_price
    if round_trip? && return_schedules.any?
      price_modifier * return_schedules.first.price.value
    end
  end

  def lower_total_price
    if round_trip? && (lower_depart_price.present? && lower_return_price.present?)
      lower_depart_price + lower_return_price
    elsif !round_trip? && lower_depart_price.present?
      lower_depart_price
    end
  end

  protected

  def different_city_for_origin_and_destination
    if origin == destination
      errors.add :destination, "As cidades de origem e de destino devem ser diferentes"
    end
  end

  def depart_date_range
    if end_depart_datetime < start_depart_datetime
      errors.add :depart_range, "A data máxima para partida deve ser superior à mínima"
    end
  end

  def return_date_range
    if end_return_datetime < start_return_datetime
      errors.add :return_range, "A data máxima para retorno deve ser superior à mínima"
    end
  end

  def depart_date_in_the_future
    if end_depart_datetime < DateTime.current
      errors.add :depart_range, "Sua disponibilidade de partida deve ser uma data futura"
    end
  end

  def return_date_in_the_future
    if end_return_datetime < DateTime.current
      errors.add :return_range, "Sua disponibilidade de retorno deve ser uma data futura"
    end
  end

  def depart_date_higher_then_return_date
    if end_return_datetime < end_depart_datetime
      errors.add :return_range, "Sua disponibilidade para viagem de retorno deve ser superior a de partida"
    end
  end

  def maximum_depart_range
    if ((end_depart_datetime - start_depart_datetime) / 3600).round > 72
      errors.add(:depart_range, "Sua disponibilidade de viagem para partida deve ter no máximo 3 dias")
    end
  end

  def maximum_return_range
    if ((end_depart_datetime - start_depart_datetime) / 3600).round > 72
      errors.add :return_range, "Sua disponibilidade de viagem para retorno deve ter no máximo 3 dias"
    end
  end

  def maximum_travel_length_per_user
    if user.travels.avaliable.length >= MAXIMUM_TRAVELS_PER_USER
      errors.add :base, "Cadastrar #{MAXIMUM_TRAVELS_PER_USER} viagens não é o suficiente pra você?"
    end
  end

  def set_null_to_return_datetime
    self.start_return_datetime = nil
    self.end_return_datetime   = nil
  end

  def find_or_create_flights
    self.flights = []
    depart_range = start_depart_datetime.to_date..end_depart_datetime.to_date
    depart_range.each do |date|
      flights << Flight.find_or_create_by_origin_id_and_destination_id_and_date(origin_id, destination_id, date)
    end

    if round_trip?
      return_range = start_return_datetime.to_date..end_return_datetime.to_date
      return_range.each do |date|
        flights << Flight.find_or_create_by_origin_id_and_destination_id_and_date(destination_id, origin_id, date)
      end
    end
  end

  def price_modifier
    adults + (children * 0.6)
  end
end
