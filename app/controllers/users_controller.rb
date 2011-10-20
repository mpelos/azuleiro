# encoding: UTF-8
class UsersController < ApplicationController
  load_and_authorize_resource

  skip_before_filter :require_login

  def new
    if current_user
      redirect_to root_path
    end
  end

  def create
    if @user.save
      login @user.email, params[:user][:password], false
      redirect_to root_url, :notice => "Obrigado por se cadastrar. Seja bem vindo."
    else
      render :new
    end
  end

  def edit
    if params[:id].nil?
      @user = current_user
    end
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Sua Senha foi alterada com sucesso."
    else
      render :edit
    end
  end
end
