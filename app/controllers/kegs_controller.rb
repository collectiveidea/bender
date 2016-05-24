class KegsController < ApplicationController
  respond_to :html, :json

  def index
    @kegs = Keg.order('started_at DESC NULLS FIRST')
    @kegs = @kegs.where(active: true) if params[:active] == 'true'
    respond_to do |wants|
      wants.html
      wants.json { render json: @kegs.preload(:beer_tap) }
    end
  end

  def show
    @keg = Keg.find(params[:id])
    respond_with @keg
  end
end
