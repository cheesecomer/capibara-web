class AddDeletedAtToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :deleted_at, :datetime
  end
end
