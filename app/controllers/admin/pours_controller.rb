class Admin::PoursController < ApplicationController
  respond_to :html, :json

  def index
    @keg = Keg.find(params[:keg_id])
    @pours = @keg.pours.for_listing.page(params[:page])
    respond_with @pours
  end

  def destroy
    keg = Keg.find(params[:keg_id])
    pour = keg.pours.find(params[:id])
    pour.destroy
    redirect_to :back
  end
end
