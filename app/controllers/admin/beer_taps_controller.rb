class Admin::BeerTapsController < ApplicationController
  respond_to :html, :json

  def index
    @beer_taps = BeerTap.order(:display_order)
    respond_to do |wants|
      wants.html
      wants.json { render json: @beer_taps.preload(:active_keg) }
    end
  end

  def show
    @beer_tap = BeerTap.find(params[:id])
    respond_with @beer_tap
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
    if @beer_tap.update_attributes(beer_tap_params)
      redirect_to [:admin, @beer_tap]
    else
      render :edit
    end
  end

  protected

  def beer_tap_params
    params.require(:beer_tap).permit(:name, :gpio_pin, :temperature_sensor_id, :ml_per_tick, :display_order)
  end
end
