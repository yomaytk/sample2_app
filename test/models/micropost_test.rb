require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

	def setup
		@user = users(:michael)
		@micropost = @user.microposts.build(content: "example string")
	end

	test "micropost should be valid" do
		assert @micropost.valid?
	end

	test "micropost with user_id being nil should be invalid" do
		@micropost.user_id = nil
		assert @micropost.invalid?
	end

	test "content should be presence" do
		@micropost.content = ""
		assert @micropost.invalid?
	end

	test "size of content should be less than 140 characters" do
		@micropost.content = "a" * 141
		assert @micropost.invalid?
	end

	test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
