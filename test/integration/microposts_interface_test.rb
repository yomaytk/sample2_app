require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
	
	def setup
		@user = users(:michael)
		@other_user = users(:malory)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
		assert_select 'div.pagination'
		assert_select 'input[type=file]'
    # invalid submit
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # valid submit
		content = "This micropost really ties the room together"
		picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
			post microposts_path, params: { micropost: { content: content,
																										picture: picture } }
		end
		assert assigns(:micropost).picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # delete my own post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # access other user (confirm no link to delete)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
	end

	test "microposts count is right?" do
		# confirm count of user having multiple microposts
		log_in_as(@user)
		get root_path
		count = @user.feed_own.count
		assert_match "#{count} microposts", response.body
		# confirm count of user having one micropos
		log_in_as(@other_user)
		post microposts_path, params: { micropost: { content: "malory chan" } }
		get root_path
		count = @other_user.microposts.count
		assert_match "1 micropost", response.body
	end

	test "reply micropost test" do
		log_in_as(@user)
		get root_path
		to_user_id = @other_user.id_number
		assert_difference 'Micropost.count', 1 do
			post microposts_path, params: { micropost: { content: "@#{to_user_id}.reply" } }
		end
		assert_difference "@other_user.feed.count", 1 do
			post microposts_path, params: { micropost: { content: "@#{to_user_id}.reply" } }
		end
		assert_difference "@user.feed.count", 1 do
			post microposts_path, params: { micropost: { content: "@#{to_user_id}.reply" } }
		end
		assert_no_difference "Micropost.count" do
			post microposts_path, params: { micropost: { content: "@WhoAreYou.reply" } }
		end
	end

end
