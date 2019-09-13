class Micropost < ApplicationRecord
	
	belongs_to :user
	default_scope -> { order(created_at: :desc) }
	mount_uploader :picture, PictureUploader
	validates	 :user_id, presence: true
	validates :content, presence: true, length: { maximum: 140 }
	validate :picture_size

	def including_replies 
		if content[0] == "@"
			at_to_user = content.split(".")[0]
			in_reply_to = at_to_user[1, at_to_user.length-1]
		end
	end

	private

    # validate the picture uploaded
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
