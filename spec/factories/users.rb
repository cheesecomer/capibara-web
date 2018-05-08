# == Schema Information
#
# Table name: users
#
#  id                        :bigint(8)        not null, primary key
#  nickname                  :string(255)      not null
#  email                     :string(191)
#  encrypted_password        :string(255)
#  reset_password_token      :string(191)
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :string(255)
#  last_sign_in_ip           :string(255)
#  access_token              :string(191)
#  biography                 :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  icon                      :string(255)
#  oauth_provider            :integer
#  oauth_access_token        :string(255)
#  oauth_access_token_secret :string(255)
#  oauth_uid                 :string(255)
#  deleted_at                :datetime
#  accepted                  :boolean          default(FALSE), not null
#  last_device_id            :string(255)
#
# Indexes
#
#  index_users_on_access_token          (access_token) UNIQUE
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

FactoryBot.define do
  factory :user do
    email     { FFaker::Internet.email }
    password  'password'
    after(:build) do |user|
      girl = Precure.all.sample
      user.nickname  = girl[:precure_name]
      user.biography = girl[:transform_message]
    end
  end
end
