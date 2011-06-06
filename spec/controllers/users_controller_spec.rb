require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'index'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in used" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        Factory(:user, :email => "another@blackburn.ac.uk")
#        Factory(:user, :email => "another@example.net")

        30.times do
          Factory(:user, :email => Factory.next(:email))
        end
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector('title', :content => "All Users")
      end
      it "shoulkd have an element for each user" do
        get :index
        User.paginate(:page => 1).each do |user|
          response.should have_selector('li', :content => user.name)
        end
      end

      it "should paginate users" do
        get :index
        response.should have_selector('div.pagination')
        response.should have_selector('span.disabled', :content => "Previous")
        response.should have_selector('a', :href => "/users?page=2",
                                      :content => "2")
        response.should have_selector('a', :href => "/users?page=2",
                                      :content => "Next")
      end

      it "should have a delete link for admins" do
        @user.toggle!(:admin)
        other_user= User.all.second
        get :index
        response.should have_selector('a', :href => user_path(other_user),
                                      :content => "delete")
      end

      it "should not have delete links for non-admins" do
        other_user= User.all.second
        get :index
        response.should_not have_selector('a', :href => user_path(other_user),
                                          :content => "delete")
      end
    end


    describe "GET 'show'" do
      before(:each) do
        @user = Factory(:user)
      end
      it "should be successful" do
        get :show, :id => @user.id
        response.should be_success
      end

      it "should show correct user" do
        get :show, :id => @user
        assigns(:user).should == @user
      end

      it "right title" do
        get :show, :id => @user
        response.should have_selector('title', :content => @user.name)
      end

      it "should have the user's name" do
        get :show, :id => @user
        response.should have_selector('h1', :content =>@user.name)
      end

      it "should have a profile image" do
        get :show, :id => @user
        response.should have_selector('h1>img', :class => "gravatar")
      end

      it "should have the right url" do
        get :show, :id => @user
        response.should have_selector('td>a', :content => user_path(@user),
                                      :href => user_path(@user))
      end

      it "should show the user's thoughts" do
        mp1 = Factory(:thought, :user => @user, :content => "hahaha")
        mp2 = Factory(:thought, :user => @user, :content => "nananana")
        get :show, :id => @user
        response.should have_selector('span.content', :content => mp1.content)
        response.should have_selector('span.content', :content => mp2.content)
      end

      it "should paginate thoughts" do
        39.times { Factory(:thought, :user => @user, :content =>"example") }
        get :show, :id => @user
        response.should have_selector('div.pagination')
      end

      it "should display the thought count" do
        10.times { Factory(:thought, :user => @user, :content =>"example") }
        get :show, :id => @user
        response.should have_selector('td.sidebar',
                                      :content => @user.thoughts.count.to_s)
      end

      describe "when signed in as another user" do
        it "should be successful" do
          test_sign_in(Factory(:user, :email => Factory.next(:email)))
          get :show, :id => @user
          response.should be_success
        end
      end
    end

    describe "GET 'new'" do
      it "should be successful" do
        get :new
        response.should be_success
      end
      it "should have the right title" do
        get :new
        response.should have_selector("title", :content => "Sign up")
      end
    end

    describe "POST 'create'" do
      describe "failure" do
        before(:each) do
          @attr = {:name => "", :email => "", :password => "",
                   :password_confirmation => ""}


        end
        it "should have the right title" do
          post :create, :user => @attr
          response.should have_selector('title', :content => "Sign up")
        end

        it "should render the 'new' page" do
          post :create, :user => @attr
          response.should render_template('new')
        end

        it "should not create a user" do
          lambda do
            post :create, :user => @attr
          end.should_not change(User, :count)
        end
      end
    end
    describe "success" do
      before(:each) do
        @attr = {:name =>"New User", :email => "user@blackburn.ac.uk",
                 :password => "testing", :password_confirmation => "testing"

        }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to UCC!/i
      end

      it "should sign user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end


    end

    describe "GET 'edit'" do
      before (:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should be successful" do
        get :edit, :id => @user
        response.should be_success
      end

      it "should have the right title" do
        get :edit, :id => @user
        response.should have_selector('title', :content =>"Edit User")
      end

      it "should have alink to change gravatar" do
        get :edit, :id => @user
        response.should have_selector('a', :href => 'http://gravatar.com/emails',
                                      :content => 'Change')
      end
    end

    describe "PUT 'update'" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      describe "failure" do
        before (:each) do
          @attr = {:name => "", :email => "", :password => "",
                   :password_confirmation => ""}

        end

        it "should render the edit page" do
          put :update, :id => @user, :user =>@attr
          response.should render_template("edit")
        end

        it "should have the right title" do
          put :update, :id => @user, :user =>@attr
          response.should have_selector('title', :content=> "Edit User")
        end
#      it "should have flash msg" do
#        put :update, :id => @user, :user => @attr
#        flash[:error].should =~ /Profile Can Not Be Updated/i
#      end

      end

      describe "success" do
        before(:each) do
          @attr = {:name =>"New Name", :email => "user@blackburn.ac.uk",
                   :password => "testing", :password_confirmation => "testing"}

        end

        it "should update the users attr" do
          put :update, :id => @user, :user => @attr
          user = assigns(:user)
          @user.reload
          @user.name.should == user.name
          @user.email.should == user.email
          @user.encrypted_password.should == user.encrypted_password
        end

        it "should have flash msg" do
          put :update, :id => @user, :user => @attr
          flash[:success].should =~ /Profile Updated/
        end
      end

    end

    describe "Authentication of edit/update actions" do
      before(:each) do
        @user = Factory(:user)
      end

      describe "for non-signed in users" do
        it "should deny access to 'edit'" do
          get :edit, :id => @user
          response.should redirect_to(signin_path)
          flash[:notice].should =~ /sign in/i
        end

        it "should deny access to 'update'" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(signin_path)
        end

      end

      describe "signed in users" do
        before(:each) do
          wrong_user = Factory(:user, :email => "user@blackburn.ac.uk")
          test_sign_in(wrong_user)
        end

        it "should require matching users for edit" do
          get :edit, :id => @user
          response.should redirect_to(root_path)
        end
        it "should require matching users for update" do
          put :update, :id =>@user, :user => {}
          response.should redirect_to(root_path)
        end
      end

    end

    describe "DELETE 'destory'" do
      before(:each) do
        @user = Factory(:user)

      end

      describe "As a non-sgined in user" do
        it "should deny access" do
          delete :destroy, :id => @user
          response.should redirect_to(signin_path)
        end

      end

      describe "As non admin" do
        it "should protect the action" do
          test_sign_in(@user)
          delete :destroy, :id => @user
          response.should redirect_to(root_path)
        end
      end

      describe "as admin" do

        before(:each) do
          @admin = Factory(:user, :email => "admin@blackburn.ac.uk", :admin => true)
          test_sign_in(@admin)
        end
        it "should destroy the user" do
          lambda do
            delete :destroy, :id => @user
          end.should change(User, :count).by(-1)

        end

        it "should redirect to the users page" do
          delete :destroy, :id => @user
          flash[:success].should =~ /destroyed/i
          response.should redirect_to(users_path)
        end

        it "should not be able to destroy self" do
          lambda do
            delete :destroy, :id => @admin
          end.should_not change(User, :count)


        end
      end

    end
  end

end
