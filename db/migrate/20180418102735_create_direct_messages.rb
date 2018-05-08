class CreateDirectMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :direct_messages, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_bin' do |t|
      t.integer :addressee_id, null: false
      t.integer :sender_id, null: false
      t.text :content
      t.timestamps
    end
  end
end
