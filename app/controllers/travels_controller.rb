class TravelsController < ApplicationController
  def index
    @travels = current_user.travels.all
  end

  def show
    @travel = current_user.travels.find(params[:id])
  end

  def new
    @travel = current_user.travels.new
  end

  def edit
    @travel = current_user.travels.find(params[:id])
  end

  def create
    @travel = current_user.travels.new(params[:travel])

    if @travel.save
      redirect_to @travel, :notice => "Sua viagem foi cadastrada com sucesso."
    else
      render :action => "new"
    end
  end

  def update
    @travel = current_user.travels.find(params[:id])

    if @travel.update_attributes(params[:travel])
      redirect_to @travel, :notice => "Sua viagem foi alterada com sucesso."
    else
      render :action => "edit"
    end
  end

  def destroy
    @travel = current_user.travels.find(params[:id])
    @travel.destroy

    redirect_to travels_url
  end
end
