class KegsController < ApplicationController
  respond_to :html, :json

  def index
    @kegs = Keg.order('started_at DESC NULLS FIRST')
    respond_with @kegs
  end

  def show
    @keg = Keg.find(params[:id])
    respond_with @keg
  end
end
