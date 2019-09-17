class UsersController < ApplicationController
	
	before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
	before_action :correct_user, only: [:edit, :update]
	before_action :admin_user, only: [:destroy]

	def index
		@users = User.where(activated: true).paginate(page: params[:page])
	end

  def show
		@user = User.find(params[:id])
		@microposts = @user.feed_own.paginate(page: params[:page])
		redirect_to root_url and return unless @user.activated?
  end

  def new
		@user = User.new
  end

  def create
		@user = User.new(user_params)
		if @user.save
			@user.send_activation_email
			flash[:info] = "Please check your email to activate your account."
			redirect_to root_url
		else
			render 'new'
		end
	end
	
	def edit
	end

	def update
		if @user.update(user_params)
			flash[:success] = "Profile Updated!"
			redirect_to @user
		else
			render "edit"
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User deleted!"
		redirect_to users_url
	end

	def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
	end

	def follower_notification_email
		
	end
	
	private

    def user_params
			params.require(:user).permit(:name, :email, :id_number,
																		:password, :password_confirmation, :follower_notification_flag)
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_url) unless current_user?(@user)
		end

		def admin_user
			if !current_user.admin?
				redirect_to root_url
			end
		end
end
