class WallMessagesController < ApplicationController

  before_filter :authenticate

  def create

    @wall_message = WallMessage.new(params[:wall_message])
    @wall_message.user_id = params[:user_id]
    @wall_message.sender_id = current_user.id

      if @wall_message.save
        redirect_to root_path, :flash => {:success => "Your wall message has been sent!"}
        set_parent

      end


  end

  def update
    @wall_message = WallMessage.find(params[:id])
    respond_to do |format|
      if @wall_message.update_attributes(params[:wall_message])
        flash[:notice] = "The wall message has been updated!"
        format.html { redirect_to(@wall_message)}
      else
        format.html { render :action => "edit"}
      end


    end

  end

  def destroy
    @wall_message = WallMessage.find(params[:id])
    set_parent
    @wall_message.destroy
    redirect_to root_path
  end

  private

  def set_parent
    @user = User.find(@wall_message.user_id)
    @parent = @user
  end


end
