class UsersController < ApplicationController
  respond_to :html, :json

  def index
    @users = User.all

    respond_with @users
  end

  def show
    @user = User.where("id = ? OR rfid = ?", params[:id], params[:user_rfid]).first!
    respond_with @user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      respond_to do |format|
        format.json { respond_with @user }
        format.html do
          flash[:success] = 'User created'
          redirect_to root_path
        end
      end
    else
      render :new
    end
  end

  protected

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
