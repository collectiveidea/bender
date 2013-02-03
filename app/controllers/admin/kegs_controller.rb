class Admin::KegsController < ApplicationController
  def index
    @kegs = Keg.all
  end

  def show
    @keg = Keg.find(params[:id])
  end

  def new
    @keg = Keg.new
  end

  def create
    @keg = Keg.new(params[:keg])
    if @keg.save
      redirect_to [:admin, @keg]
    else
      render :new
    end
  end

  def edit
    @keg = Keg.find(params[:id])
  end

  def update
    @keg = Keg.find(params[:id])
    if @keg.update_attributes(params[:keg])
      redirect_to [:admin, @keg]
    else
      render :edit
    end
  end
  
end
