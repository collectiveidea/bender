class Admin::PoursController < ApplicationController
  def index
    @keg = Keg.find(params[:keg_id])
    @pagy, @pours = pagy(@keg.pours.for_listing)
  end

  def destroy
    keg = Keg.find(params[:keg_id])
    pour = keg.pours.find(params[:id])
    pour.destroy
    redirect_to :back
  end
end
