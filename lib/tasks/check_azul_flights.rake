require 'headless'

namespace :flights do
  desc "Check Azul's website and notify if price is lower or equal then the stipulated price"
  task :check => :environment do
    AzulWatcher.new.update_flight_prices

    Travel.where(["end_depart_datetime >= ?", 2.hours.from_now]).each do |travel|
      if travel.lower_total_price <= travel.maximum_price
        # ScheduleMailer.notify_lower_price(travel).deliver
        puts "Enviei um e-mail"
      end
    end
  end
end
