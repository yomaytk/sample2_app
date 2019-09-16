class MicropostsController < ApplicationController

	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user, only: [:destroy]
	
	def create
		@micropost = current_user.microposts.build(micropost_params)
		@micropost.in_reply_to = @micropost.including_replies
		@micropost.messages_to_id = -1
		to_user_str = @micropost.in_reply_to
		to_user = User.find_by(id_number: to_user_str)
		to_user_id = to_user.id_number unless to_user.nil?
		to_user_name = to_user.name 	unless to_user.nil?
		if @micropost.valid?
			if to_user_str.nil?
				flash[:success] = "Micropost is created!"
				@micropost.save
			elsif !to_user_str.nil? && to_user.nil?
				flash[:danger] = "Cannot find the reply user..."
			else
				flash[:success] = "reply to \"#{to_user_name}\"(@#{to_user_id})!"
				@micropost.save
			end
			redirect_to root_url
		else
			@feed_items = current_user.feed.paginate(page: params[:page])			
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		flash[:success] = "Micropost is deleted!"
		redirect_to request.referrer || root_url		# <-- redirect_back(fallback_location: root_url)
	end

	private

		def correct_user
			@micropost = current_user.microposts.find_by(id: params[:id])
			redirect_to root_url if @micropost.nil?
		end

end
