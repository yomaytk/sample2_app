class MessagesController < ApplicationController

	before_action :user_right?, only: [:show]

	def show
		@user = User.find(params[:id1])
		@you = User.find(params[:id2])
		@microposts = @user.message_feed(@you)
		@micropost = @user.microposts.build
		render 'users/message'
	end
	
	def create
		@micropost = current_user.microposts.build(micropost_params)
		@user = User.find(params[:id1])
		@you = User.find(params[:id2])
		@micropost.messages_to_id = params[:id2]
		if @micropost.save
			flash[:success] = "send message to #{@you.name}(#{@you.id_number})!"
			render 'users/message'
		else
			flash[:danger] = "fail to send..."
			render 'users/message'
		end
	end

	private

		def user_right?
			@user = User.find(params[:id1])
			unless current_user == @user
				flash[:danger] = "cannot watch private messages of other user"
				redirect_to root_url
			end
		end

end
