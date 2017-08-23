module Api
  module V1
    class UsersController < ApiController
      def show
        user = User.find_by(rfid: auth_params)
        render json: Oj.dump(user, mode: :compat)
      end

      private

      def auth_params
        params.require(:rfid)
      end
    end
  end
end
