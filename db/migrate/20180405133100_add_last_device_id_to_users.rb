class AddLastDeviceIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_device_id, :string
  end
end
