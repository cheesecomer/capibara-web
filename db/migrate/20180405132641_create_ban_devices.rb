class CreateBanDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :ban_devices do |t|
      t.text :device_id, null: false
      t.timestamps
    end
  end
end
