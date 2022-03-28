module API
  module V1
    class UsersController < ApplicationController
      def index
        @users = User.active

        render json: Oj.dump(@users.as_json, mode: :compat)
      end

      def show
        # Looks up via id or rfid. Previous API used user_rfid.
        @user = User.where(id: params[:id]).or(User.where(rfid: params[:id])).sole
        render json: Oj.dump(@user.as_json, mode: :compat)
      end

      def create
        @user = User.new(user_params)

        if @user.save
          render json: Oj.dump(@user.as_json, mode: :compat), status: :created
        else
          render json: Oj.dump(@user.errors.to_json, mode: :compat), status: :unprocessible_entity
        end
      end

      protected

      def user_params
        params.require(:user).permit(:name, :email, :rfid)
      end
    end
  end
end
