require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  
	def setup
		@user = users(:michael)
		@other = users(:archer)
		@user3 = users(:tester)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
	end
	
	test "should follow a user the standard way" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
  end

  test "should follow a user with Ajax" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
  end

  test "should unfollow a user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
	end
	
	test "feed on Home page" do
    get root_path
    @user.feed.paginate(page: 1).each do |micropost|
      assert_match (micropost.content), response.body			
    end
	end
	
	test "follower notification checkbox test" do
		assert_difference "Relationship.count", 1 do
			@user.follow(@user3)
		end
		@user.unfollow(@user3)
		assert_emails 0 do
			@user.follow(@user3)
		end
		patch user_path(@user3), params: { user: { name: @user3.name, 
																							email: @user3.email,
																							password: "", 
																							password_confirmation: "",
																							follower_notification_flag: 1 } }
		@user.unfollow(@user3)
		mail = UserMailer.follower_notification(@user, @other)
		assert_emails 1 do
			mail.deliver_now
		end
	end

end
