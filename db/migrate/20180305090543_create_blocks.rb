class CreateBlocks < ActiveRecord::Migration[5.1]
  def change
    create_table :blocks, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_bin' do |t|
      t.integer :owner_id, null: false
      t.integer :target_id, null: false
      t.timestamps
    end
  end
end
