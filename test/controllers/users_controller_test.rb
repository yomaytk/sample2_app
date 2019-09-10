require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:michael)
		@other_user = users(:archer)
	end

  test "should get new" do
    get signup_path
    assert_response :success
	end
	
	test "should redirect edit when not logged in" do
		log_in_as(@other_user)
		get edit_user_path(@user)
		assert flash.empty?
		assert_redirected_to root_url
	end

	test "should redirect update when not logged in" do
		log_in_as(@other_user)
		patch user_path(@user), params: { user: { name: @user.name, 
																							email: @user.email } }
		assert flash.empty?
		assert_redirected_to root_url
	end

	test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
	end
	
	test "should not allow user to change admin attribute" do
		log_in_as(@other_user)
		assert_not @other_user.admin?
		patch user_path(@other_user), params: {
																		user: { name: @other_user.name,
																						email: @other_user.email,
																						password:              "",
                                            password_confirmation: "",
                                            admin: true } }
		assert_not @other_user.reload.admin?
	end

	test "should redirected to login_url with logout user" do
		assert_no_difference "User.count" do
			delete user_path(@other_user)
		end
		assert_redirected_to login_url
	end

	test "should redirected to root_url with logged user no having admin-right" do
		log_in_as(@other_user)
		assert_no_difference "User.count" do
			delete user_path(@user)
		end
		assert_redirected_to root_url
	end

end
