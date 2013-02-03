class Admin::BeerTapsController < ApplicationController
  def index
    @beer_taps = BeerTap.all
  end

  def show
    @beer_tap = BeerTap.find(params[:id])
  end

  def new
    @beer_tap = BeerTap.new
  end

  def create
    @beer_tap = BeerTap.new(params[:beer_tap])
    if @beer_tap.save
      redirect_to [:admin, @beer_tap]
    else
      render :new
    end
  end

  def edit
    @beer_tap = BeerTap.find(params[:id])
  end

  def update
    @beer_tap = BeerTap.find(params[:id])
    if @beer_tap.update_attributes(params[:beer_tap])
      redirect_to [:admin, @beer_tap]
    else
      render :edit
    end
  end
end
