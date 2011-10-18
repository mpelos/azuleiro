class TravelsController < ApplicationController
  def index
    @travels = Travel.all
  end

  def show
    @travel = Travel.find(params[:id])
  end

  def new
    @travel = Travel.new
  end

  def edit
    @travel = Travel.find(params[:id])
  end

  def create
    @travel = Travel.new(params[:travel])

    if @travel.save
      redirect_to @travel, :notice => "Sua viagem foi cadastrada com sucesso."
    else
      render :action => "new"
    end
  end

  def update
    @travel = Travel.find(params[:id])

    if @travel.update_attributes(params[:travel])
      redirect_to @travel, :notice => "Sua viagem foi alterada com sucesso."
    else
      render :action => "edit"
    end
  end

  def destroy
    @travel = Travel.find(params[:id])
    @travel.destroy

    format.html redirect_to(travels_url)
  end
end
