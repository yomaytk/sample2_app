require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
	
	def setup
		@user = users(:michael)
		@other = users(:archer)
	end

	test "messages function" do
		# confirm login user messages
		log_in_as(@user)
		assert_equal @user.id, 762146111
		assert_equal @other.id, 950961012
		get "/users/#{@user.id}/messages/#{@other.id}"
		message_feed_count = @user.message_feed(@other).count
		assert_equal message_feed_count, 3
		assert_match "Microposts (#{message_feed_count})", response.body
		# confirm cannot watch other user messages
		delete logout_path
		assert_not is_logged_in?
		get root_path
		assert_template 'static_pages/home'
		log_in_as(@other)
		get "/users/#{@user.id}/messages/#{@other.id}"
		assert_not flash[:danger].empty?
		# confirm logout user cannot access other private messages
		delete logout_path
		assert_not is_logged_in?
		get "/users/#{@user.id}/messages/#{@other.id}"
		assert_not flash[:danger].empty?
  end

end