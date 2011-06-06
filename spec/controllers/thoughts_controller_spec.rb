require 'spec_helper'

describe ThoughtsController do
  render_views

  describe "access control" do
    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id =>1
      response.should redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "failure" do
      before(:each) do
        @attr ={:content => ""}
      end

      it "should not create a thought" do
        lambda do
          post :create, :thought => @attr
        end.should_not change(Thought, :count)
      end

      it "should render the home page" do
        post :create, :thought => @attr
        response.should render_template('pages/home')

      end
    end

    describe "success" do
      before(:each) do
        @attr = {:content => "Lorem Isum Dolor"}

      end
      it "should create a thought" do
        lambda do
          post :create, :thought => @attr
        end.should change(Thought, :count).by(1)
      end

      it "should re-direct to root path" do
        post :create, :thought => @attr
        response.should redirect_to(root_path)
      end

      it "should have a flash success message" do
        post :create, :thought => @attr
        flash[:success].should =~ /thought created/i
      end
    end
  end

  describe "DELETE 'destroy'" do
    describe "for an unauthorised user" do
      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        @thought = Factory(:thought, :user => @user)
        test_sign_in(wrong_user)
      end

      it "should deny access" do
        delete :destroy, :id => @thought
        response.should redirect_to(root_path)
      end
    end

    describe "for an auth user" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        @thought = Factory(:thought, :user => @user)

      end

      it "should delete thought" do
        lambda do
          delete :destroy, :id => @thought
          flash[:success].should =~ /Message Deleted/i
          response.should redirect_to(root_path)
        end.should change(Thought, :count).by(-1)
      end
    end
  end


end