require 'headless'

namespace :flights do
  desc "Check Azul's website and notify if price is lower or equal then the stipulated price"
  task :check => :environment do
    headless = Headless.new
    headless.start

    FlightSchedule.where(["depart_at >= ?", Time.now]).each do |schedule|
      previous_price = schedule.current_price || 0
      schedule.update_current_price
      if (schedule.current_price <= schedule.maximum_price) && (schedule.current_price != previous_price)
        ScheduleMailer.notify_lower_price(schedule).deliver
      end
    end

    headless.destroy
  end
end
