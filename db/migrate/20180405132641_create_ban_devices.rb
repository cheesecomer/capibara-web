class CreateBanDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :ban_devices, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_bin' do |t|
      t.text :device_id, null: false
      t.timestamps
    end
  end
end
