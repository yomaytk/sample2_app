require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
	
	def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
	end

	test "password reset" do
		get new_password_reset_path
		assert_template '/password_reset/new'
		#	invalid email address
		post password_reset_path, params: { password_reset: { email: "wrong" } }
		assert_not flash.empty?
		assert_template 'password_reset/new'
		# valid email address
		post password_reset_path, params: { password_reset: { email: @user.email } }
		assert_not_equal @user.reset_digest, @user.reload.reset_digest
		assert_equal 1, ActionMailer::Base.deliveries.size
		assert_not flash.empty?
		assert_redirected_to root_url
		####
		user = assigns(:user)
	end
end
