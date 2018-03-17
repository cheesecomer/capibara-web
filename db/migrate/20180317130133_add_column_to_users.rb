class AddColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :oauth_provider, :integer, limit: 1
    add_column :users, :oauth_access_token, :string
    add_column :users, :oauth_access_token_secret, :string
    add_column :users, :oauth_uid, :string
  end
end
