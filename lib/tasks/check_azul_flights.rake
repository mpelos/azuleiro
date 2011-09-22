require 'headless'

namespace :flights do
  desc "Check Azul's website and notify if price is lower or equal then the stipulated price"
  task :check => :environment do
    headless = Headless.new
    headless.start

    Schedule.where(["depart_at >= ?", Time.now]).each do |schedule|
      puts schedule.check_flight_price_on_website

      if schedule.flight_price <= schedule.maximum_price
        ScheduleMailer.notify_lower_price(schedule).deliver
      end
    end

    headless.destroy
  end
end
