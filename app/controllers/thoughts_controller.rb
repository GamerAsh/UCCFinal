class ThoughtsController < ApplicationController

  before_filter :authenticate
  before_filter :authorised_user, :only => :destroy

  def create
    @thought = current_user.thoughts.build(params[:thought])
    if @thought.save
      redirect_to root_path, :flash => {:success => "Thought Created!"}

    else
      @feed_items = []

      render 'pages/home'

    end
  end

  def destroy
    @thought.destroy
    redirect_to root_path, :flash => {:success => "Message Deleted!"}
  end

  private

  def authorised_user
    @thought = Thought.find(params[:id])
    redirect_to root_path unless current_user?(@thought.user)
  end


end