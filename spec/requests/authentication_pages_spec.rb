require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin" do
  	before { visit signin_path }

  	describe "with invalid information" do
  		before { click_button "Sign in" }

  		it { should have_selector('h1', text: 'Sign in') }
  		it { should have_selector('div.alert.alert-error', text: "Invalid") }

  		describe "after visiting another page" do
		    # send it to another page
		    before { click_link "Home" }
		    # it should not have the error div
		    it { should_not have_selector('div.alert.alert-error') }
		  end
  	end

  	describe "with valid information" do
  		let(:user) { FactoryGirl.create(:user) }
  		before { sign_in user }

  		it { should have_selector('title', text: user.name) }
  		it { should have_link('Profile', href: user_path(user)) }
  		it { should have_link('Sign out', href: signout_path) }
  		it { should_not have_link('Sign in', href: signin_path) }
      it { should have_link('Settings', href: edit_user_path(user)) }

  		describe "after saving the user" do
  			it { should have_link('Sign out') }
  		end

  		describe "sign out" do
		  	before { click_link "Sign out" }
		  	it { should have_link("Sign in", href: signin_path) }
		  end
  	end

    describe "authorization" do

      # try to edit or update but not signed in
      describe "for non-signed in users" do
        #create a dummy user
        let(:user) { FactoryGirl.create(:user) }

        describe "when attempting to visit a protected page" do
          before do
            visit edit_user_path(user)
            fill_in "Email",    with: user.email
            fill_in "Password", with: user.password
            click_button "Sign in"
          end

          describe "after signing in" do

            it "should render the desired protected page" do
              page.should have_selector('title', text: 'Edit user')
            end
          end
        end

        describe "in the Users controller" do

          describe "visiting the edit page" do
            # when visiting edit page...
            before { visit edit_user_path(user) }

            # redirects to sign in page
            it { should have_selector('title', text: 'Sign in') }
          end

          describe "submitting to the update action" do
            # when sending put commands to server...
            before { put user_path(user) }

            # redirects to sign in page
            specify { response.should redirect_to(signin_path) }
          end
        end
      end

      # sign in and try to edit or update someone elses profile
      describe "as wrong user" do
        #create a 2 dummy users and sign one in
        let(:user) { FactoryGirl.create(user) }
        let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
        before { sign_in user }

        # go to another edit page
        describe "visit Users#Edit page" do
          before { visit edit_user_path(wrong_user) }
          it { should_not have_selector('title', text: full_title('Edit')) }
        end

        describe "submitting a PUT request to Users#update" do
          before { put user_path(wrong_user) }
          specify { response.should redirect_to(root_path) }
        end
      end
    end
  end
end
