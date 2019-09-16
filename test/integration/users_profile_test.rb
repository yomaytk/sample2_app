require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
		@user = users(:michael)
		@other = users(:archer)
  end

	test "profile display on own user" do
		log_in_as(@user)
		get user_path(@user)
		@other = @user
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.feed_own.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
		end
		assert_match @user.following.count.to_s, response.body
		assert_match @user.followers.count.to_s, response.body
		assert_select "a[href=?]", "/users/#{@user.id}/messages/#{@other.id}", count: 0
	end

	test "profile display on other user" do
		log_in_as(@user)
		get user_path(@other)
		assert_select "a[href=?]", "/users/#{@user.id}/messages/#{@other.id}", count: 1
		assert_match "Send messages", response.body
	end

end