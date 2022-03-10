module API
  module V1
    class UsersController < ApplicationController
      def index
        @users = User.all

        render json: Oj.dump(@users.as_json, mode: :compat)
      end

      def show
        # Looks up via id or rfid. Previous API used user_rfid.
        @user = User.where(id: params[:id]).or(User.where(rfid: params[:id])).sole
        render json: Oj.dump(@user.as_json, mode: :compat)
      end
    end
  end
end