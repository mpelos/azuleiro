class AzulWatcher
  require 'headless'

  def update_flight_prices
    headless = Headless.new
    headless.start

    @session = Capybara::Session.new(:webkit)
    @session.visit("http://www.voeazul.com.br")

    @session.find(".jqTransformSelectOpen").click
    @session.execute_script("$('input[value=OneWay]').removeClass('jqTransformHidden');")
    @session.choose("AvailabilitySearchInputSearchView22$RadioButtonMarketStructure")

    Flight.where("date >= ?", Date.current).each do |flight|
      if flight.travels.any?
        select_origin_city      flight.origin.code
        select_destination_city flight.destination.code
        select_depart_date      flight.date
        submit

        if @session.has_xpath? "//table[@class='info-table']"
          @session.find(:xpath, "//table[@class='info-table']").text.split(/\n[0-9]{4}/).drop(1).each do |text|
            localized_time = text.match(/\d{2}:\d{2}/).to_s
            schedule = Schedule.find_or_create_by_datetime(DateTime.parse("#{flight.date.to_s} #{localized_time}:00 #{DateTime.current.formatted_offset}"))
            price = Price.find_or_create_by_value(text.match(/\d*\.*\d+,\d{2}/).to_s.delete(".").sub(",", ".").to_f)

            flight.schedules << schedule
            flight.prices << price
            schedule.price = price
          end
        end
      end
    end
  end

  protected
    def select_origin_city(city_code)
      if @session.current_url == "http://www.voeazul.com.br/"
        @session.execute_script "comboAzul.selecionou('#{city_code}', this,'.txtBusca3', 'true', 'origem', 'Estouem2', '#{city_code}');"
      else
        @session.execute_script "setDropAirport('#{city_code}','AvailabilitySearchInputSelectView2_DropDownListMarketOrigin1')"
      end
    end

    def select_destination_city(city_code)
      if @session.current_url == "http://www.voeazul.com.br/"
        @session.execute_script "comboAzul.selecionou('#{city_code}', this,'.txtBusca4', 'true', 'destino', 'Estouem2', '#{city_code}');"
      else
        @session.execute_script "setDropAirport('#{city_code}','AvailabilitySearchInputSelectView2_DropDownListMarketDestination1')"
      end

    end

    def select_depart_date(date)
      if @session.current_url == "http://www.voeazul.com.br/"
        @session.fill_in "somenteidaData1", :with => I18n.l(date)
      else
        @session.execute_script "showBuyBlock();"
        @session.execute_script "$('#AvailabilitySearchInputSelectView2_DropDownListMarketDay1').show();"
        @session.execute_script "$('#AvailabilitySearchInputSelectView2_DropDownListMarketMonth1').show();"
        @session.select I18n.l(date, :format => :only_day), :from => "AvailabilitySearchInputSelectView2_DropDownListMarketDay1"
        @session.select I18n.l(date, :format => :discard_day), :from => "AvailabilitySearchInputSelectView2_DropDownListMarketMonth1"
      end
    end

    def submit
      if @session.current_url == "http://www.voeazul.com.br/"
        @session.find("#btn-somenteida").click
      else
        @session.click_link "AvailabilitySearchInputSelectView2_LinkButtonNewSearch"
      end
    end
end
