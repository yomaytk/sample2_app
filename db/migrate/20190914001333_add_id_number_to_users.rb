class AddIdNumberToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :id_number, :string
  end
end
