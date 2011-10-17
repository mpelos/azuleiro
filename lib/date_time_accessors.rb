module DateTimeAccessors
  require "active_record"

  def split_date_and_time(*attributes)
    attributes.each do |attribute|
      date = attribute.to_s.sub("datetime", "date")
      time = attribute.to_s.sub("datetime", "time")

      define_method date do
        send(attribute).present? ? send(attribute).strftime("%d/%m/%Y") : Date.tomorrow.strftime("%d/%m/%Y")
      end

      define_method time do
        send(attribute).present? ? send(attribute).strftime("%H:%M") : "00:00"
      end

      define_method "#{date}=" do |value|
        instance_variable_set "@#{date}", value
      end

      define_method "#{time}=" do |value|
        instance_variable_set "@#{time}", value
      end

      validates_presence_of date, time

      before_validation do
        if instance_variable_get("@#{date}").present?
          self.send "#{attribute}=", DateTime.strptime([instance_variable_get("@#{date}"), instance_variable_get("@#{time}")].join(" "), "%d/%m/%Y %H:%M").to_formatted_s(:db)
        end
      end
    end
  end
end
