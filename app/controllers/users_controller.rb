class UsersController < ApplicationController
  def index
    @users = User.active
  end

  def show
    @user = User.where("id = ? OR rfid = ?", params[:id], params[:user_rfid]).first!
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'User created'
      redirect_to root_path
    else
      render :new
    end
  end

  protected

  def user_params
    params.require(:user).permit(:name, :email, :rfid)
  end
end
