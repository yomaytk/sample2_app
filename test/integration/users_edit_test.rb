require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
	
	def setup
		@user = users(:michael)
		@user3 = users(:tester)
	end

	test "unsuccesful edit" do
		log_in_as(@user)
		get edit_user_path(@user)
		assert_template 'users/edit'
		patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password: "foo",
                                              password_confirmation: "bar" } }
		assert_template 'users/edit'
		assert_select "div.alert", "The form contains 4 errors."
	end

	test "succesuful edit" do
		get edit_user_path(@user)
		assert_equal session[:forwarding_url], edit_user_url(@user)
		log_in_as(@user)
		assert_redirected_to edit_user_url(@user)
		assert_nil session[:forwarding_url]
		name = "Foo Bar"
		email = "foo@bar.com"
		patch user_path(@user), params: { user: { name: name, 
																							email: email,
																							password: "", 
																							password_confirmation: "" } }
		assert_not flash.empty?
		assert_redirected_to @user
		@user.reload
		assert_equal name, @user.name
		assert_equal email, @user.email
	end

	# test "follower notification checkbox test" do
	# 	log_in_as(@user3)
	# 	assert_difference "Relationship.count", 1 do
	# 		@user3.follow(@user1)
	# 	end
	# 	# assert_emails 0 do
	# 	# 	@user3.follow(@user1)
	# 	# end
	# 	# log_in_as(user1)
	# end

end
