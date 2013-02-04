class PoursController < ApplicationController
  def new
    @users = User.order(:name)
  end

  def create
    tap = BeerTap.find(params[:beer_tap_id])
    user = User.find(params[:user_id]) if params[:user_id] != '0'
    pour = tap.active_keg.start_pour(user)
    redirect_to pour
  end

  def show
    @pour = Pour.find(params[:id])
    redirect_to root_path if @pour.finished_at
  end

  def volume
    @pour = Pour.find(params[:pour_id])
    output = @pour.volume ? "You have poured <span>#{'%0.2f' % @pour.volume} oz." : ""
    render text: output, layout: false
  end
end
