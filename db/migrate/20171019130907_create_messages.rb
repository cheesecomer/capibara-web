class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_bin' do |t|
      t.string :content
      t.integer :sender_id
      t.integer :room_id

      t.timestamps
    end
  end
end
