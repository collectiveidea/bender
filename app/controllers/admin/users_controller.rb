class Admin::UsersController < ApplicationController
  http_basic_authenticate_with name: "bender", password: Setting.admin_password, if: :needs_authetication?

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.attributes = user_params

    if @user.save
      flash[:success] = 'User updated'
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to admin_users_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'User created'
      redirect_to admin_users_path
    else
      render :new
    end
  end

  protected

  def user_params
    params.require(:user).permit(:name, :email, :rfid, :credits)
  end

  private

  def needs_authetication?
    Setting.admin_password.present?
  end
end
