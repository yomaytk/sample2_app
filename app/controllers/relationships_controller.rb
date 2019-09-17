class RelationshipsController < ApplicationController

	before_action :logged_in_user

	def create
    @user = User.find(params[:followed_id])
		current_user.follow(@user)
		if @user.follower_notification_flag == 1
			@user.send_follower_notification_email(current_user)
		end
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

end
