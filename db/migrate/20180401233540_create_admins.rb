class CreateAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :admins do |t|
      t.string :nickname, null: false

      ## Database authenticatable
      t.string :email, limit: 191
      t.string :encrypted_password

      ## Recoverable
      t.string   :reset_password_token, limit: 191
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps
    end

    # Add Index
    add_index :admins, :email,                unique: true
    add_index :admins, :reset_password_token, unique: true
  end
end
