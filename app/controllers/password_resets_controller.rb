# encoding: UTF-8
class PasswordResetsController < ApplicationController
  skip_before_filter :require_login

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_reset_password_instructions!
      redirect_to(root_path, :notice => "Um e-mail foi enviado para você.")
    else
      flash.now.alert = "Esse e-mail não foi encontrado. Você digitou corretamente?"
      render :new
    end
  end

  def edit
    @user = User.load_from_reset_password_token(params[:token])
    not_authenticated if @user.nil?
  end

  def update
    @user = User.load_from_reset_password_token(params[:id])
    not_authenticated if @user.nil?

    if @user.update_attributes(params[:user])
      login(@user.email, params[:user][:password], false) if @user.active?
      redirect_to(root_path, :notice => "Sua senha foi alterada. Guarde-a com carinho.")
    else
      render :action => "edit"
    end
  end
end
