class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_bin' do |t|
      t.string :name, limit: 255
      t.integer :capacity, null: false, limit: 1
      t.integer :priority, null: false, limit: 1

      t.timestamps
    end
  end
end
