# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  nickname               :string(255)      not null
#  email                  :string(191)
#  encrypted_password     :string(255)
#  reset_password_token   :string(191)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  access_token           :string(191)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_access_token          (access_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :update_access_token!

  validates :nickname, presence: true

  attr_accessor :is_api_request

  after_initialize do
    self.is_api_request = false
  end

  def update_access_token!
    self.access_token = Digest::SHA256.hexdigest SecureRandom.uuid
    save and return self
  end

  def to_broadcast_hash
    {
      id: self.id,
      nickname: self.nickname
    }
  end

  protected

  def email_required?
    !self.is_api_request
  end

  def password_required?
    !self.is_api_request
  end
end
