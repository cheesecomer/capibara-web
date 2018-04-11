class AddContentToInformation < ActiveRecord::Migration[5.1]
  def change
    add_column :information, :content, :text
  end
end
