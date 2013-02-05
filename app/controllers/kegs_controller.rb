class KegsController < ApplicationController
  def show
    @keg = Keg.find(params[:id])
  end
end
