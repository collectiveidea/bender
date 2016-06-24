module Api
  module V1
    class UsersController < ApiController
      def show
        user = User.find params[:id]
        render json: Oj.dump(user.stats, mode: :compat)
      end
    end
  end
end
