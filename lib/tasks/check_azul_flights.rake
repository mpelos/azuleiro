require 'headless'

namespace :flights do
  desc "Check Azul's website and notify if price is lower or equal then the stipulated price"
  task :check => :environment do
    headless = Headless.new
    headless.start

    AzulWatcher.new.update_flight_prices

    # headless.destroy
  end
end
