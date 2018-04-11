class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_bin' do |t|
      t.integer :sender_id, null: false
      t.integer :target_id, null: false
      t.integer :reason, null: false
      t.string :message
      t.timestamps
    end
  end
end
