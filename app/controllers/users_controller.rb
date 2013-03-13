class UsersController < ApplicationController
  respond_to :html, :json

  def index
    @users = User.all
    respond_with @users
  end

  def show
    @user = User.find(params[:id])
    respond_with @user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
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
end
