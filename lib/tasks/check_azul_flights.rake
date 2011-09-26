require 'headless'

namespace :flights do
  desc "Check Azul's website and notify if price is lower or equal then the stipulated price"
  task :check => :environment do
    AzulWatcher.new.update_flight_prices

    FlightSchedule.where(["end_depart_datetime >= ?", 2.hours.from_now]).each do |schedule|
      if schedule.lower_total_price <= schedule.maximum_price
        ScheduleMailer.notify_lower_price(schedule).deliver
      end
    end
  end
end
