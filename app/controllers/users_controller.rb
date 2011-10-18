# encoding: UTF-8

class UsersController < ApplicationController
  skip_before_filter :require_login

  def new
    if current_user.present?
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      login @user.email, params[:user][:password], false
      redirect_to root_url, :notice => "Obrigado por se cadastrar. Seja bem vindo."
    else
      render :new
    end
  end
end
