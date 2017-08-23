module Api
  module V1
    class AuthController < ApiController
      def create
        user = User.find_by(rfid: auth_params)
        unless user.pours_remaining?
          render status: :forbidden, text: "Insufficient credits remaining"
          return
        end

        render json: Oj.dump(user, mode: :compat)
      end

      private

      def auth_params
        params.require(:rfid)
      end

    end
  end
end
