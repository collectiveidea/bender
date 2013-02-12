class UsersController < ApplicationController
  respond_to :html, :json

  def index
    @users = User.all
    respond_with @users
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = 'User created'
      redirect_to root_path
    else
      render :new
    end
  end
end
