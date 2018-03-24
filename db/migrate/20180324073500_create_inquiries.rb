class CreateInquiries < ActiveRecord::Migration[5.1]
  def change
    create_table :inquiries do |t|
      t.integer :sender_id
      t.string :name
      t.string :email, limit: 191, null: false
      t.text :content, null: false
      t.text :reply
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
