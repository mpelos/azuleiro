# encoding: UFT-8

class ScheduleMailer < ActionMailer::Base
  default :from => "verificador_azul@randomhost.com.br"

  def notify_lower_price(schedule)
    @schedule = schedule
    mail :to => schedule.recipients.gsub!(" ", "").split(","), :subject => "Vôo agendado da azul com preço inferior ao estipulado"
  end
end
