class AzulWatcher
  require 'headless'

  def update_flight_prices
    headless = Headless.new
    headless.start

    @session = Capybara::Session.new(:webkit)
    @session.visit("http://viajemais.voeazul.com.br")

    select_one_way_radio
    select_one_adult

    Flight.where("date >= ?", Date.current).each do |flight|
      select_origin_city      flight.origin.code
      select_destination_city flight.destination.code
      select_depart_date      flight.date
      @session.click_link     "COMPRE AGORA"

      if @session.has_xpath? "//table[@class='info-table']"
        @session.find(:xpath, "//table[@class='info-table']").text.split("\nvoo ").drop(1).each do |text|
          localized_time = text.match(/\d{2}:\d{2}/).to_s
          schedule = Schedule.find_or_create_by_datetime(DateTime.parse("#{flight.date.to_s} #{localized_time}:00 #{DateTime.current.formatted_offset}"))
          price = Price.find_or_create_by_value(text.match(/\d+,\d{2}/).to_s.sub!(",", ".").to_f)

          flight.schedules << schedule
          flight.prices << price
          schedule.price = price
        end
      end
    end
  end

  protected
    def select_one_way_radio
      if @session.current_url == "http://viajemais.voeazul.com.br/"
        radio_button = "#ControlGroupMainSearchView2_AvailabilitySearchInputSearchView2_OneWay"
      else
        radio_button = "#AvailabilitySearchInputSelectView2_OneWay"
      end

      @session.find(radio_button).click
    end

    def select_origin_city(city_code)
      if @session.current_url == "http://viajemais.voeazul.com.br/"
        select_box = "ControlGroupMainSearchView2_AvailabilitySearchInputSearchView2_DropDownListMarketOrigin1"
      else
        select_box = "AvailabilitySearchInputSelectView2_DropDownListMarketOrigin1"
      end

      @session.execute_script "setDropAirport('#{city_code}','#{select_box}')"
    end

    def select_destination_city(city_code)
      if @session.current_url == "http://viajemais.voeazul.com.br/"
        select_box = "ControlGroupMainSearchView2_AvailabilitySearchInputSearchView2_DropDownListMarketDestination1"
      else
        select_box = "AvailabilitySearchInputSelectView2_DropDownListMarketDestination1"
      end

      @session.execute_script "setDropAirport('#{city_code}','#{select_box}')"
    end

    def select_depart_date(date)
      if @session.current_url == "http://viajemais.voeazul.com.br/"
        day_select_box = "ControlGroupMainSearchView2_AvailabilitySearchInputSearchView2_DropDownListMarketDay1"
        month_year_select_box = "ControlGroupMainSearchView2_AvailabilitySearchInputSearchView2_DropDownListMarketMonth1"
      else
        day_select_box = "AvailabilitySearchInputSelectView2_DropDownListMarketDay1"
        month_year_select_box = "AvailabilitySearchInputSelectView2_DropDownListMarketMonth1"
      end

      @session.select I18n.l(date, :format => :only_day), :from => day_select_box
      @session.select I18n.l(date, :format => :discard_day), :from => month_year_select_box
    end

    def select_one_adult
      @session.select "1", :from => "ControlGroupMainSearchView2$AvailabilitySearchInputSearchView2$DropDownListPassengerType_ADT"
    end
end
