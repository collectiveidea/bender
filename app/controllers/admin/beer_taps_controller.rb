class Admin::BeerTapsController < ApplicationController
  def index
    @beer_taps = BeerTap.order(:display_order)
  end

  def show
    @beer_tap = BeerTap.find(params[:id])
  end

  def new
    @beer_tap = BeerTap.new
  end

  def create
    @beer_tap = BeerTap.new(beer_tap_params)
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
    if @beer_tap.update(beer_tap_params)
      redirect_to [:admin, @beer_tap]
    else
      render :edit
    end
  end

  def toggle_cleaning
    @beer_tap = BeerTap.find(params[:beer_tap_id])
    @beer_tap.toggle_cleaning
    redirect_to [:admin, @beer_tap]
  end

  protected

  def beer_tap_params
    params.require(:beer_tap).permit(:name, :gpio_pin, :valve_pin, :temperature_sensor_id, :ml_per_tick, :display_order)
  end
end
