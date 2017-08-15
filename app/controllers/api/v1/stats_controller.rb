module Api
  module V1
    class StatsController < ApiController
      def index
        user = User.where("id = ? OR rfid = ?", params[:user_id], params[:user_rfid]).first!
        render json: Oj.dump(user.stats, mode: :compat)
      end
    end
  end
end
