class ChangeDatatypeContentOfMessages < ActiveRecord::Migration[5.1]
  def change
    change_column :messages, :content, :text
  end
end
