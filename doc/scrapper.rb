require "capybara"

session = Capybara::Session.new(:selenium)
session.visit("http://viajemais.voeazul.com.br")

# Abre caixa de origem
session.execute_script "showDropAirport('1d');"

# Seleciona Viracopos - Campinas
session.execute_script "setDropAirport('VCP','ControlGroupMainSearchView2_AvailabilitySearchInputSearchView2_DropDownListMarketOrigin1')"

# Abre caixa de destino
session.execute_script "showDropAirport('1a');"

# Seleciona Joinville
session.execute_script "setDropAirport('JOI','ControlGroupMainSearchView2_AvailabilitySearchInputSearchView2_DropDownListMarketDestination1')"

# Seleciona quantos adultos
session.select "1", :from => "ControlGroupMainSearchView2$AvailabilitySearchInputSearchView2$DropDownListPassengerType_ADT"

session.click_link "COMPRE AGORA"
