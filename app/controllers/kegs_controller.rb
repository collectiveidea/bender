class KegsController < ApplicationController
  respond_to :html, :json

  def index
    @kegs = Keg.order('started_at DESC NULLS FIRST')
    respond_to do |wants|
      wants.html
      wants.json { render json: @kegs.preload(:beer_tap).to_json(include: [:beer_tap]) }
    end
  end

  def show
    @keg = Keg.find(params[:id])
    respond_with @keg
  end
end
