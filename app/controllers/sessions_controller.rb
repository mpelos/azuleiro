# encoding: UTF-8
class SessionsController < ApplicationController
  skip_before_filter :require_login, :except => :destroy

  def new
    if current_user.present?
      redirect_to root_path
    end
  end

  def create
    user = login(params[:email], params[:password], params[:remember_me])

    if user && (user.active? || user.administrator?)
      redirect_back_or_to root_url, :notice => "Seja bem vindo de volta."
    elsif user && user.inactive?
      logout
      redirect_to root_path(:email => params[:email]), :alert => "Sinto muito, mas você ainda não pode entrar."
    else
      flash.now.alert = "Ooops. E-mail ou senha inválidos."
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end
