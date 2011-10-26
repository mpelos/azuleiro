# encoding: UTF-8
class ApplicationMailer < ActionMailer::Base
  default :from => "verificador_azul@randomhost.com.br"

  def user_waiting_for_approval(user)
    @user = user
    mail :to => User.administrators.collect(&:email), :subject => "#{user.email} aguardando aprovação"
  end

  def user_approved(user)
    @user = user
    mail :to => user.email, :subject => "Sua conta foi aprovada"
  end

  def affordable_price(travel)
    @travel = travel
    mail :to => travel.recipients.gsub(" ", "").split(","), :subject => "O voo na azul para #{travel.destination} está com preço acessível"
  end
end
