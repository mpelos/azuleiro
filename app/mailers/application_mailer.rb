# encoding: UTF-8
class ApplicationMailer < ActionMailer::Base
  default :from => "Azuleiro <azuleiro@randomhost.com.br>"

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
    mail :to => travel.recipients.gsub(" ", "").split(","), :subject => "O voo na Azul para #{travel.destination} está com preço acessível"
  end

  def reset_password_email(user)
    @user = user
    mail(:to => user.email, :subject => "Sua senha está pronta para ser alterada")
  end
end
