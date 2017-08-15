class UsersController < ApplicationController
  http_basic_authenticate_with name: "bender", password: Setting.admin_password, if: :needs_authetication?, except: [:index, :show, :new, :create]

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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.attributes = user_params

    if @user.save
      respond_to do |format|
        format.json { respond_with @user }
        format.html do
          flash[:success] = 'User updated'
          redirect_to users_path
        end
      end
    else
      render :edit
    end
  end

  protected

  def user_params
    params.require(:user).permit(:name, :email)
  end

  private

  def needs_authetication?
    Setting.admin_password.present?
  end
end
