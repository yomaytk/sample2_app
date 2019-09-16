class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.integer :from
      t.integer :to

      t.timestamps
		end
		add_index :messages, :from
		add_index :messages, :to
  end
end
