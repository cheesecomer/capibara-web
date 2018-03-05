class CreateBlocks < ActiveRecord::Migration[5.1]
  def change
    create_table :blocks do |t|
      t.integer :owner_id, null: false
      t.integer :target_id, null: false
      t.timestamps
    end
  end
end
