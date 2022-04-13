class KegsController < ApplicationController
  def index
    @kegs = Keg.order("started_at DESC NULLS FIRST")
    @kegs = @kegs.where(active: true) if params[:active] == "true"
  end

  def show
    @keg = Keg.find(params[:id])
  end
end
