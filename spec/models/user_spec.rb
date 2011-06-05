require 'spec_helper'

describe User do
  
  before(:each) do
    @attr =     {
    :name => "Example User",
    :email => "User@blackburn.ac.uk",
    :password => "testing",
    :password_confirmation => "testing"
    }
  end
  it "should create a new instance given a valid attr" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name =>""))
    no_name_user.should_not be_valid
  end
  
  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email =>""))
    no_email_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user= User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@blackburn.ac.uk THE_USER@blackburn.ac.uk first.last@blackburn.ac.uk]
    addresses.each do |address|
       valid_email_user = User.new(@attr.merge(:email => address))
       valid_email_user.should be_valid
    end
  end
  
  it "should reject email addresses" do
    addresses = %w[user@foo,com THE_USER_at_foor.bar.org first.last@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email =>address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email address" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "passwords" do
    
    before(:each) do
      @user = User.new(@attr)
    end
    it "should have a password attribute" do
      User.new(@attr).should respond_to(:password)
    end
    
    it "should have a password confirmation" do
      @user.should respond_to(:password_confirmation)
      
    end
  end
  
  describe "password validations" do
    it "should have require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
      should_not be_valid
    end
    
    it "should require a confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
      should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    
    it "should reject long pass" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end
  
  describe "password encryption" do
    before(:each) do
      @user = User.create(@attr)
    end
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
      
      
    end
      it "should set the enc password att" do
    @user.encrypted_password.should_not be_blank
  end
  it "should have a salt" do
    @user.should respond_to(:salt)
  end
  
  describe "has_password? method" do
    it "should exist" do
      @user.should respond_to(:has_password?)
    end
    it "should return true if match" do
      @user.has_password?(@attr[:password]).should be_true
    end
    
    it "should return flase if not match"do
      @user.has_password?("invalid").should be_false
    end
  end
  
  describe "Auth method" do
    it "should exist" do
      User.should respond_to(:authenticate)
    end
    it "should return nil on email/pass mismatch" do
      User.authenticate(@attr[:email], "wrongpass").should be_nil      
    end
    
    it "should return nil for an email add with no user" do
      User.authenticate("bar@foo.com", @attr[:password]).should be_nil
    end
    
    it "should reutn the user on a match" do
      User.authenticate(@attr[:email], @attr[:password]).should == @user
    end
  end
  end

  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end
    it "should respond to admin" do
      @user.should respond_to(:admin)

    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end

  end
  describe "thought associations" do
    before(:each) do
      @user = User.create(@attr)
      @t1 = Factory(:thought, :user => @user, :created_at => 1.day.ago)
      @t2 = Factory(:thought, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have a thought attr" do
      @user.should respond_to(:thoughts)
    end

    it "should have the right thoughts in the right order" do
      @user.thoughts.should == [@t2, @t1]
    end

    it "should destroy accociated thoughts" do
      @user.destroy
      [@t1, @t2].each do |thought|
        lambda do
          Thought.find(thought)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
        
    end

    describe "status feed" do
      it "should have a feed" do
      @user.should respond_to(:feed)
    end

      it "should include the users thoughts" do
        @user.feed.should include(@t1)
        @user.feed.should include(@t2)
      end


  end

  end


  
end
