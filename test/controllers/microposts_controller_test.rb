require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
	
	def setup
		@micropost = microposts(:orange)
		@user = users(:michael)
		@other_user = users(:archer)
	end

	test "logout user should redirect to login url and reject post request about micropost" do
		assert_no_difference "Micropost.count" do
			post microposts_path, params: { micropost: { content: "hahahahaha" } }
		end
		assert_redirected_to login_url
	end

	test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
	end
	
	test "user must not delete the micropost of other user" do
		log_in_as(@user)
		micropost = microposts(:ants)
		# micropost2 = @user.microposts.find(1)
		assert_no_difference "Micropost.count" do
			delete micropost_path(micropost)
		end
		assert_redirected_to root_url
	end

end
