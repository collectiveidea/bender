module Api
  module V1
    class PoursController < ApiController
      def index
        @pours = Pour.for_listing.
          between_dates(start_time: start_time, end_time: end_time)

        render json: @pours
      end

      private

      def start_time
        if params[:start_time]
          Time.zone.parse(params[:start_time])
        end
      end

      def end_time
        if params[:end_time]
          Time.zone.parse(params[:end_time])
        end
      end
    end
  end
end
