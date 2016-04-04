class PoursController < ApplicationController
  respond_to :html, :json

  def index
    @pours = Pour.for_listing.
      between_dates(start_time: start_time, end_time: end_time).
      page(params[:page])

    respond_with @pours
  end

  def new
    @users = User.where(['name != ?', 'Guest']).order(:name)
  end

  def create
    tap = BeerTap.find(params[:beer_tap_id])
    user = User.find(params[:user_id]) if params[:user_id] != '0'
    pour = tap.active_keg.start_pour(user)

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

  def edit
    @pour = Pour.find(params[:id])
    @users = User.where(['name != ?', 'Guest']).order(:name)
  end

  def update
    pour = Pour.update(params[:id], pour_params)
    respond_to do |format|
      format.json { respond_with pour }
      format.html { redirect_to(params[:back_to] || root_path) }
    end
  end

  def volume
    @pour = Pour.find(params[:pour_id])
    output = @pour.volume ? "You have poured <span>#{'%0.2f' % @pour.volume} oz." : ''
    render text: output, layout: false
  end

  protected

  def pour_params
    params.require(:pour).permit(:user_id)
  end

  def start_time
    if params[:start_time]
      Time.zone.parse(params[:start_time])
    end
  end

  def end_time
    if params[:end_time]
      Time.zone.parse(params[:end_time])
    end
  end
end
