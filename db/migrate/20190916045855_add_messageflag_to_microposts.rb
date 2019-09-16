class AddMessageflagToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :messages_to_id, :integer
  end
end
