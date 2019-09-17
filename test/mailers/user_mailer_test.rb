require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

	def setup
		@user1 = users(:michael)
		@user2 = users(:archer)
		@user3 = users(:tester)
	end

	test "account_activation" do
		user = users(:michael)
		user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
		assert_equal ["noreply@example.com"], mail.from
		assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end

	test "password_reset" do
		user = users(:michael)
		user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
	end
	
	test "follower_notification" do
		user1 = users(:michael)
		user2 = users(:archer)
		mail = UserMailer.follower_notification(user1, user2)
		assert_equal "You are followed!", mail.subject
		assert_equal [user1.email], mail.to
		assert_equal ["noreply@example.com"], mail.from
		assert_match user2.name, mail.body.encoded
		# confirm add queue after send email (whatever email send or not?)
		assert_emails 1 do						
      mail.deliver_now
		end
		assert_match "#{user2.name}", mail.body.encoded
	end

end
