require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  end
  
  describe "signup" do

      before { visit signup_path }

      describe "with invalid information" do
        it "should not create a user" do
          expect { click_button "Create my account" }.not_to change(User, :count)
        end
      end

      describe "with valid information" do
        before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "user@example.com"
          fill_in "Password",     with: "foobar"
          fill_in "Confirmation", with: "foobar"
        end

        it "should create a user" do
          expect do
            click_button "Create my account"
          end.to change(User, :count).by(1)
        end
        
        describe "after saving the user" do
          before { click_button "Create my account" }
          let(:user) { User.find_by_email('user@example.com') }

          it { should have_selector('title', text: user.name) }
          it { should have_selector('div.alert.alert-success', text: 'Welcome') }
          it { should have_link('Sign out') }
          
        end
      end
    end
  end
    describe "signin" do

        before { visit signin_path }

        describe "with invalid information" do
          before { click_button "Sign in" }

          it { should have_selector('title', text: 'Sign in') }
          it { should have_selector('div.alert.alert-error', text: 'Invalid') }

          describe "after visiting another page" do
            before { click_link "Home" }
            it { should_not have_selector('div.alert.alert-error') }
          end
          
          describe "followed by signout" do
                before { click_link "Sign out" }
                it { should have_link('Sign in') }
              end
        end
  end
