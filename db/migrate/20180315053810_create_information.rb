class CreateInformation < ActiveRecord::Migration[5.1]
  def change
    create_table :information do |t|
      t.string :title, null: false
      t.string :message, null: false
      t.datetime :published_at, null: false
      t.timestamps
    end
  end
end
