class DropParticipants < ActiveRecord::Migration[5.1]
  def change
    drop_table :participants
  end
end
