module API
  module V1
    class AuthController < APIController
      def create
        user = User.find_by(rfid: auth_params)

        if user && user.pours_remaining?
          render json: Oj.dump(user.stats, mode: :compat)
        else
          render status: :forbidden, plain: "Insufficient credits remaining"
        end
      end

      private

      def auth_params
        params.require(:rfid)
      end

    end
  end
end
