class Admin::PoursController < ApplicationController
  def index
    @keg = Keg.find(params[:keg_id])
    @pours = @keg.pours.for_listing.page(params[:page])
  end

  def destroy
    keg = Keg.find(params[:keg_id])
    pour = keg.pours.find(params[:id])
    pour.destroy
    redirect_to :back
  end
end
