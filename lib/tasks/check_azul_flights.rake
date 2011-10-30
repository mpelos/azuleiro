require 'headless'

namespace :flights do
  desc "Check Azul's website and notify if price is lower or equal then the stipulated price"
  task :check => :environment do
    AzulWatcher.new.update_flight_prices

    Travel.available.each do |travel|
      if travel.lower_total_price.present? && (travel.lower_total_price <= travel.maximum_price)
        ApplicationMailer.affordable_price(travel)
      end
    end
  end
end
