require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
	
	def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
	end

	test "password reset" do
		get new_password_reset_path
		assert_template 'password_resets/new'
		#	invalid email address
		post password_resets_path, params: { password_reset: { email: "wrong" } }
		assert_not flash.empty?
		assert_template 'password_resets/new'
		# valid email address
		post password_resets_path, params: { password_reset: { email: @user.email } }
		assert_not_equal @user.reset_digest, @user.reload.reset_digest
		assert_equal 1, ActionMailer::Base.deliveries.size
		assert_not flash.empty?
		assert_redirected_to root_url
		####
		user = assigns(:user)
		# get link with wrong email address
		get edit_password_reset_path(user.reset_token, email: "wrong")	# <-- captured by valid_user method
		assert_redirected_to root_url
		# get link with wrong token 
		get edit_password_reset_path("wrong", email: user.email)				# <-- captured by valid_user method
		assert_redirected_to root_url
		# get link with invalid user																		
		user.toggle!(:activated)																						
    get edit_password_reset_path(user.reset_token, email: user.email)			# <-- captured by valid_user method
    assert_redirected_to root_url
    user.toggle!(:activated)
		# get link with valid email address and token
		get edit_password_reset_path(user.reset_token, email: user.email)		#	Accepted
		assert_template "password_resets/edit"
		assert_select "input[name=email][type=hidden][value=?]", user.email
		# password is not equal password confirmation
		patch password_reset_path(user.reset_token), 
					params: { email: user.email, 
										user: {
														password: "foobar", 
														password_confirmation: "foobarbar"
										} 
									}
		assert_select 'div#error_explanation'
		# password should not be blank
		patch password_reset_path(user.reset_token), 
					params: { email: user.email, 
										user: {
														password: "", 
														password_confirmation: ""
										} 
									}
		assert_select 'div#error_explanation'
		# right password and password confirmation
		patch password_reset_path(user.reset_token), 
					params: { email: user.email, 
										user: {
														password: "foobar", 
														password_confirmation: "foobar"
										} 
									}
		assert is_logged_in?
		assert_not flash.empty?
		assert_redirected_to user
		assert user.reload.reset_digest.nil?
	end

	test "expired token" do
    get new_password_reset_path
    post password_resets_path,
					params: { password_reset: { email: @user.email } }

    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password:              "foobar",
                            password_confirmation: "foobar" } }
    assert_response :redirect
    follow_redirect!
    assert_match "expired", response.body
	end

end
