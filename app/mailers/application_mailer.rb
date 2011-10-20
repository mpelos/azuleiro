# encoding: UTF-8
class ApplicationMailer < ActionMailer::Base
  default :from => "verificador_azul@randomhost.com.br"

  def user_waiting_for_approval
    @user = user
    mail :to => User.administrators.collect(&:email), :subject => "#{user.email} aguardando aprovação"
  end

  def user_approved
    @user = user
    mail :to => user.email, :subject => "Sua conta foi aprovada"
  end
end
