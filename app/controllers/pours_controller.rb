class PoursController < ApplicationController
  def index
    @pagy, @pours = pagy(Pour.for_listing)
  end

  def new
    @users = User.where.not(name: "Guest").order(:name)
  end

  def create
    user = User.where("id = ? OR rfid = ?", params[:user_id], params[:user_rfid]).first! if params[:user_id] != "0"
    unless user.pours_remaining?
      render status: :forbidden, plain: "Insufficient credits remaining"
      return
    end

    tap = BeerTap.find(params[:beer_tap_id])
    pour = tap.active_keg.start_pour(user)

    redirect_to pour
  end

  def show
    @pour = Pour.find(params[:id])
    redirect_to root_path if @pour.finished_at
  end

  def edit
    @pour = Pour.find(params[:id])
    @users = User.where.not(name: "Guest").order(:name)
  end

  def update
    pour = Pour.find(params[:id])
    if params.require(:pour).keys == ["finished_at"]
      pour.finish_pour(params[:pour][:finished_at])
    else
      pour.update!(pour_params)
    end
    redirect_to(params[:back_to] || root_path)
  end

  def volume
    @pour = Pour.find(params[:pour_id])
    output = @pour.volume ? "You have poured <span>#{"%0.2f" % @pour.volume} oz." : ""
    render text: output, layout: false
  end

  protected

  def pour_params
    params.require(:pour).permit(:user_id)
  end
end
