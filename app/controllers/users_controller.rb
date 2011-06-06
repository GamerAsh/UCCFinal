class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create, :recover]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy

  def index
    @users = User.paginate(:page => params[:page])
    @title = "All Users"
  end

  def show
    @user = User.find(params[:id])
    @thoughts = @user.thoughts.paginate(:page => params[:page])
#    @wall_messages = @user
    @title = @user.name
  end


  def new
    @user = User.new
    @title = "Sign up"
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user

      redirect_to @user, :flash => {:success => "Welcome to UCC!"}
      Welcome.registration_confirmation(@user).deliver
    else

      @title = "Sign up"
      render 'new'
    end
  end

  def edit

    @title = "Edit User"
  end

  def update

    if @user.update_attributes(params[:user])

      redirect_to @user, :flash => {:success => "Profile Updated"}
    else

      @title = "Edit User"
      render 'edit'
#      redirect_to @user, :flash => {:error => "Profile Can Not Be Updated"}
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path, :flash => {:success => "User destroyed."}
  end

  private


  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)

  end

  def admin_user
    @user = User.find(params[:id])
    redirect_to(root_path) if (!current_user.admin? || current_user?(@user))
  end
end


