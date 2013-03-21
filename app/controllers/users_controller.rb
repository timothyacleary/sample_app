class UsersController < ApplicationController

  # before filters run methods defined in user_helpers for certain User methods
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:destroy]
  before_filter :signed_out_user, only: [:new, :create]

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
      sign_in @user
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "You successfully updated your information"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def signed_in_user
      unless signed_in?
        # stores attempted url
        store_location
        # sends to sign in page
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      # pull in the user info from the database
      @user = User.find(params[:id])

      # send to the root page unless they are the current user
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      # redirect to root unles current user is an admin
      redirect_to(root_path) unless current_user.admin?
    end

    def signed_out_user
      redirect_to root_path, notice: "Please sign out before attempting" unless !signed_in?
    end
end
