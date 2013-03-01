class KegsController < ApplicationController
  respond_to :html, :json

  def index
    @kegs = Keg.where(active: true)
    respond_with @kegs
  end

  def show
    @keg = Keg.find(params[:id])
    respond_with @keg
  end
end