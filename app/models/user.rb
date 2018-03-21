# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
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
#
# Indexes
#
#  index_users_on_access_token          (access_token) UNIQUE
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :update_access_token!

  validates :nickname, presence: true

  attr_accessor :is_api_request

  mount_base64_uploader :icon, ImageUploader

  enum oauth_provider: {
    twitter: 1,
    line: 2
  }

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

  def self.find_or_create_from_oauth(oauth)
    provider = oauth[:provider].to_s.downcase.to_sym
    uid = oauth[:uid]
    nickname = oauth[:info][:nickname]
    name = oauth[:info][:name]
    image_url = oauth[:info][:image]
    token = oauth[:credentials][:token]
    token_secret = oauth[:credentials][:secret]
    description = oauth[:info][:description]

    self.find_or_create_by(oauth_provider: provider, oauth_uid: uid) do |user|
      user.nickname = name || nickname
      user.remote_icon_url = image_url if image_url.present?
      user.oauth_access_token = token
      user.oauth_access_token_secret = token_secret
      user.biography = description
    end
  end

  protected

  def email_required?
    !(self.is_api_request || self.oauth_provider.present?)
  end

  def password_required?
    !(self.is_api_request || self.oauth_provider.present?)
  end
end
