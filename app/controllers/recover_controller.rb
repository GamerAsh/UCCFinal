class RecoverController < ApplicationController


  def new
  end

  def create
    user = User.find_by_email(params[:user][:email])
    respond_to do |format|
      format.html do
        if user.nil?
          flash.now[:error] = "Invalid email address"
          render 'new'
        else
          Welcome.deliver_password_recover(user)
          flash[:success] = "Your password has been sent"
          redirect_to signin_url
        end
      end
    end
  end

  private

end
