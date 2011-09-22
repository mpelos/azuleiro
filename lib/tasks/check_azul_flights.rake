require 'headless'

namespace :flights do
  desc "Check Azul's website and notify if price is lower or equal then the stipulated price"
  task :check => :environment do
    headless = Headless.new
    headless.start

    Schedule.where(["depart_at >= ?", Time.now]).each do |schedule|
      if schedule.flight_price.sub("R$ ", "").sub(",", ".").to_f <= schedule.maximum_price
        ScheduleMailer.notify_lower_price(schedule).deliver
      end
    end

    headless.destroy
  end
end
