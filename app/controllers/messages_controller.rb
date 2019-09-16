class MessagesController < ApplicationController

	before_action :user_right?, only: [:show, :create]

	def show
		@user = User.find(params[:id1])
		@you = User.find(params[:id2])
		@microposts = @user.message_feed(@you).paginate(page: params[:@page])
		@micropost = @user.microposts.build
		render 'users/message'
	end
	
	def create
		@micropost = current_user.microposts.build(micropost_params)
		@user = User.find(params[:id1])
		@you = User.find(params[:id2])
		@micropost.messages_to_id = params[:id2]
		if @micropost.save
			@microposts = @user.message_feed(@you).paginate(page: params[:@page])			
			flash[:success] = "send message to #{@you.name}(@#{@you.id_number})!"
			redirect_to "/users/#{@user.id}/messages/#{@you.id}"
		else
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
