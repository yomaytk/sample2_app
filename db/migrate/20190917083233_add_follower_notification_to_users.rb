class AddFollowerNotificationToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :follower_notification_flag, :integer
  end
end
