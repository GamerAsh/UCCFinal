class FriendshipController < ApplicationController

  def req
    @user = User.signed_in?
    @friend = User.find(params[:id])
    unless @friend.nil?
      if Friendship.request(@user, @friend)
        flash[:notice] = "Friendship with #{@friend.full_name} requested"
      else
        flash[:notice] = "Friendship with #{@friend.full_name} cannot be requested"
      end
    end
    redirect_to :controller => :users, :action => :index
  end

  def show
  end

end
