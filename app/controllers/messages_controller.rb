class MessagesController < ApplicationController

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
			flash[:success] = "send to #{@you.name}(#{@you.id_number})"
			render 'users/message'
		else
			flash[:danger] = "fail to micropost"
			render 'users/message'
		end
	end

end
