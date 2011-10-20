class TravelsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @travel.save
      redirect_to @travel, :notice => "Sua viagem foi cadastrada com sucesso."
    else
      render :action => "new"
    end
  end

  def update
    if @travel.update_attributes(params[:travel])
      redirect_to @travel, :notice => "Sua viagem foi alterada com sucesso."
    else
      render :action => "edit"
    end
  end

  def destroy
    @travel.destroy

    redirect_to travels_url
  end
end
