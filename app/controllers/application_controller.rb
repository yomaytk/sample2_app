class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
  
	include SessionsHelper

	def logged_in_user
		if !logged_in?
			store_location
			flash[:danger] = "Please log in."
			redirect_to login_url
		end
	end

	private

		def micropost_params
			params.require(:micropost).permit(:content, :picture, :messages_to_id)
		end

end