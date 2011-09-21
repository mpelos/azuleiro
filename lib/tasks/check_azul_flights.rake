namespace :flights do
  desc "Check Azul's website and notify if price is lower or equal then the stipulated price"
  task :check => :environment do
    Schedule.where(["depart_at >= ?", Time.now]).each do |schedule|
      puts schedule.check_flight_price_on_website
    end
  end
end
