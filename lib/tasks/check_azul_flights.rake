require 'headless'

namespace :flights do
  desc "Check Azul's website and notify if price is lower or equal then the stipulated price"
  task :check => :environment do
    headless = Headless.new
    headless.start

    AzulWatcher.new.update_flight_prices

    FlightSchedule.where(["end_depart_datetime >= ?", Time.current]).each do |schedule|
      if schedule.lower_total_price <= schedule.maximum_price
        ScheduleMailer.notify_lower_price(schedule).deliver
      end
    end

    # headless.destroy
  end
end
