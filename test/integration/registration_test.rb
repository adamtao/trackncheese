require 'test_helper'

# Testing what you can do without even logging in.

class RegistrationIntegrationTest < ActionDispatch::IntegrationTest

	before do
		visit new_session_path
	end

	describe "Local user registration" do 

		before do 
			OmniAuth.config.test_mode = false # Use prod mode for the local identity tests
			click_on "Create an account"
		end

		after	do
			OmniAuth.config.test_mode = true
		end

		it "should raise an error with invalid credentials" do 
			u = User.count
			fill_in :email, with: "not-valid-email"
			click_on "Register"
			User.count.must_equal (u)
			current_path.must_equal '/auth/identity/register'
			must_have_content "Name can't be blank"
			must_have_content "Email is invalid"
			must_have_content "Password can't be blank"
		end

		it "should create a user and login" do 
			u = User.count
			fill_in :name, with: "Joe Schmoe"
			fill_in :email, with: "joe@schmoe.com"
			fill_in :password, with: "abc123"
			fill_in :password_confirmation, with: "abc123"
			click_on "Register"
			User.count.must_equal (u + 1)
			current_path.must_equal projects_path
		end

		it "should be able to login when returning" do
			fill_in :name, with: "Joe Schmoe"
			fill_in :email, with: "joe@schmoe.com"
			fill_in :password, with: "abc123"
			fill_in :password_confirmation, with: "abc123"
			click_on "Register"
			click_on "Logout"
			visit new_session_path
			fill_in :auth_key, with: "joe@schmoe.com"
			fill_in :password, with: "abc123"
			click_on "Login"
			current_path.must_equal projects_path
		end

		it "should show a nice error when using a wrong password" do 
			visit new_session_path
			fill_in :auth_key, with: "invalid-user-id"
			fill_in :password, with: "invalid-password"
			click_on "Login"
			current_path.must_equal new_session_path
			must_have_content "Authentication error"
		end

	end

	# Not sure how to test these...
	#
	# http://ashleshawrites.wordpress.com/2012/07/02/testing-omniauth-creating-mock-data/
	# https://github.com/intridea/omniauth/wiki/Integration-Testing
	#
	# describe "Social registrations" do
	# 	it "twitter registration should work"
	# 	it "facebook registration should work"
	# 	it "soundcloud registration should work"
	# 	it "google plus registration should work"
	# 	it "should request email address"
	# end

end