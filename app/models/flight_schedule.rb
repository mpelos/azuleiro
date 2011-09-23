# encoding: UTF-8

class FlightSchedule < ActiveRecord::Base
  require "capybara"

  include EnumerateIt

  DEPART_TABLE_HTML_ID = "GoingPrices"
  RETURN_TABLE_HTML_ID = "BackPrices"

  has_enumeration_for :origin,      :with => City
  has_enumeration_for :destination, :with => City

  validates_presence_of :origin, :destination, :depart_at, :return_at, :adults, :children, :maximum_price, :recipients

  default_scope order("depart_at", "return_at")

  def update_current_price
    session = Capybara::Session.new(:webkit)
    session.visit("http://viajemais.voeazul.com.br")

    # Abre caixa de origem
    session.execute_script "showDropAirport('1d');"

    # Seleciona a cidade de origem
    session.execute_script "setDropAirport('#{origin}','ControlGroupMainSearchView2_AvailabilitySearchInputSearchView2_DropDownListMarketOrigin1')"

    # Abre caixa de destino
    session.execute_script "showDropAirport('1a');"

    # Seleciona a cidade de destino
    session.execute_script "setDropAirport('#{destination}','ControlGroupMainSearchView2_AvailabilitySearchInputSearchView2_DropDownListMarketDestination1')"

    #Seleciona o dia de partida
    session.select I18n.l(depart_at, :format => :only_day), :from => "ControlGroupMainSearchView2$AvailabilitySearchInputSearchView2$DropDownListMarketDay1"

    #Seleciona mês-ano de partida
    session.select I18n.l(depart_at, :format => :date_without_day), :from => "ControlGroupMainSearchView2$AvailabilitySearchInputSearchView2$DropDownListMarketMonth1"

    #Seleciona o dia de retorno
    session.select I18n.l(return_at, :format => :only_day), :from => "ControlGroupMainSearchView2$AvailabilitySearchInputSearchView2$DropDownListMarketDay2"

    #Seleciona mês-ano de retorno
    session.select I18n.l(return_at, :format => :date_without_day), :from => "ControlGroupMainSearchView2$AvailabilitySearchInputSearchView2$DropDownListMarketMonth2"

    # Seleciona quantos adultos
    session.select adults.to_s, :from => "ControlGroupMainSearchView2$AvailabilitySearchInputSearchView2$DropDownListPassengerType_ADT"

    # Seleciona quantas crianças
    if children > 0
      session.select children.to_s, :from => "ControlGroupMainSearchView2$AvailabilitySearchInputSearchView2$DropDownListPassengerType_CHD"
    end

    session.click_link "COMPRE AGORA"

    # Insere a classe target nos inputs do tipo radio dos horários determinados via javascript
    session.execute_script add_class_target_to_scheduled_depart_flight
    session.execute_script add_class_target_to_scheduled_return_flight

    # Clica no input radio baseado na classe html target
    session.find("##{DEPART_TABLE_HTML_ID} .target").click
    session.find("##{RETURN_TABLE_HTML_ID} .target").click

    # Aguarda meio segundo, tempo necessário para o valor total ser atualizado via javascript, obtém o valor total e o transforma em um Float
    sleep 0.5
    current_flight_price = session.find("xtotal").text
    current_flight_price.sub(",", ".").to_f

    # Atualiza current_price com o total obtido
    update_attribute :current_price, current_flight_price
    current_flight_price
  end

  protected
    def add_class_target_to_scheduled_depart_flight
      add_class_target_to_scheduled_flight(DEPART_TABLE_HTML_ID)
    end

    def add_class_target_to_scheduled_return_flight
      add_class_target_to_scheduled_flight(RETURN_TABLE_HTML_ID)
    end

    def add_class_target_to_scheduled_flight(table_html_id)
      datetime = (table_html_id == DEPART_TABLE_HTML_ID) ? depart_at : return_at
      "jQuery('##{table_html_id} td[colspan=3]').each(function(){ if( $(this).find('.output span').text() == '#{I18n.l datetime, :format => :time_only}' ){ $(this).parent().find('.promo input').addClass('target') } })"
    end
end
