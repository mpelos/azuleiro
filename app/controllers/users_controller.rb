# encoding: UTF-8
class UsersController < ApplicationController
  load_and_authorize_resource

  skip_before_filter :require_login

  def index
    @users = User.travellers
  end

  def new
    if current_user
      redirect_to root_path
    end
  end

  def edit
    if params[:id].nil?
      @user = current_user
    end
  end

  def create
    if @user.save
      ApplicationMailer.user_waiting_for_approval(@user).deliver
      redirect_to login_url(:email => @user.email), :notice => "Seu cadastro foi para aprovação. Aguarde."
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Sua Senha foi alterada com sucesso."
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

  def activate
    User.find(params[:id]).activate!
    redirect_to users_path
  end
end
