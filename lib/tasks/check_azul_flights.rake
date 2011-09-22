require 'headless'

namespace :flights do
  desc "Check Azul's website and notify if price is lower or equal then the stipulated price"
  task :check => :environment do
    headless = Headless.new
    headless.start

    Schedule.where(["depart_at >= ?", Time.now]).each do |schedule|
      puts schedule.check_flight_price_on_website
    end

    headless.destroy
  end
end
