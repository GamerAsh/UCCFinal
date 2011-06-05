require 'spec_helper'

describe "Thoughts" do
  before(:each) do
    user= Factory(:user)
    visit signin_path
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button
  end

  describe "creation" do
    describe "failure" do
      it "should not make a newthoughtP" do
        lambda do
          visit root_path
          fill_in :thought_content, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector('div#error_explanation')
        end
      end
    end

    describe "success" do
      it "should make a new thought" do
        content = "Lorem ipsum dolor sit amet"
        lambda do
          visit root_path
          fill_in :thought_content, :with => content
          click_button
          response.should have_selector('span.content', :content => content)
        end.should change(Thought, :count).by(1)
      end
    end
  end
end
