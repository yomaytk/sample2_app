require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
	
	def setup
		@user = users(:michael)
		@other = users(:archer)
	end

	test "should get create" do
		log_in_as(@user)
		get "http://localhost:3000/users/#{@user.id}/messages/#{@other.id}"
		message_feed_count = @user.message_feed(@other).count
		assert_equal message_feed_count, 3
		# assert_match message_feed_count, response.body
  end

end
