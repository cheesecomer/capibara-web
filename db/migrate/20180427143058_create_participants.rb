class CreateParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table :participants do |t|
      t.integer :room_id, null: false
      t.integer :user_id, null: false
    end
  end
end
