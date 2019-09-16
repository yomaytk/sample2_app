require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
	def setup
		@admin = users(:michael)
		@no_admin = users(:archer)
	end

	test "index including pagination with admin user" do
		log_in_as(@admin)
		get users_path
		assert_template 'users/index'
		assert_select 'div.pagination', count: 2
		User.paginate(page: 1).each do |user|
			assert_select "a[href=?]", user_path(user), text: user.name
			if user != @admin 
				assert_select "a[href=?]", user_path(user), text: "Delete"
			end
		end
		assert_difference "User.count", -1 do
			delete user_path(@no_admin)
		end
	end

	test "index including pagination with no-admin user" do
		log_in_as(@no_admin)
		get users_path
		assert_template 'users/index'
		assert_select 'a', text: "delete", count: 0
	end

end
