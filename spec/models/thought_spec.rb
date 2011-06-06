require 'spec_helper'

describe Thought do
  before(:each) do
    @user = Factory(:user)
    @attr = {:content => "lorem ipsum"}
  end
  it "should create a new instance with valid attributes" do
    @user.thoughts.create!(@attr)
  end

  describe "User Associations" do

    before(:each) do
      @thought = @user.thoughts.create(@attr)
    end
    it "should have a user attribute" do
      @thought.should respond_to(:user)
    end

    it "should have the right associated user" do
      @thought.user_id.should == @user.id
      @thought.user.should == @user
    end
  end

  describe "validations" do
    it "should have a user id" do
      Thought.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      @user.thoughts.build(:content => "       ").should_not be_valid

    end
    it "should reject content too long" do
      @user.thoughts.build(:content => "a" * 141).should_not be_valid
    end
  end


end
