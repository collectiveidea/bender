module Api
  module V1
    class StatsController < ApiController
      def index
        user = User.find params[:user_id]
        render json: Oj.dump(user.stats, mode: :compat)
      end
    end
  end
end
