module API
  module V1
    class KegsController < ApplicationController
      def index
        @kegs = Keg.order("started_at DESC NULLS FIRST")
        @kegs = @kegs.where(active: true) if params[:active] == "true"
        render json: @kegs.preload(:beer_tap)
      end

      def show
        @keg = Keg.find(params[:id])
        render json: @keg
      end
    end
  end
end
