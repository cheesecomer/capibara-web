class AddAcceptedToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :accepted, :boolean, null: false, default: false
  end
end
