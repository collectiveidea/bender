class PoursController < ApplicationController
  respond_to :html, :json
  
  def new
    @users = User.order(:name)
  end

  def create
    tap = BeerTap.find(params[:beer_tap_id])
    user = User.find(params[:user_id]) if params[:user_id] != '0'
    pour = tap.active_keg.start_pour(user)
    #redirect_to pour

    respond_to do |format|
      format.json { respond_with pour }
      format.html { redirect_to pour }
    end
  end

  def show
    @pour = Pour.find(params[:id])
    redirect_to root_path if @pour.finished_at
    respond_with @pour
  end

  def update
    respond_with Pour.update(params[:id], params[:pour])
  end

  def volume
    @pour = Pour.find(params[:pour_id])
    output = @pour.volume ? "You have poured <span>#{'%0.2f' % @pour.volume} oz." : ""
    render text: output, layout: false
  end
end
