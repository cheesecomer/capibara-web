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
#  last_device_id            :string(255)
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

  has_many :reports, foreign_key: :sender_id

  belongs_to :ban_device, foreign_key: :last_device_id, primary_key: :device_id, optional: true

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
    line: 2,
    google: 3
  }

  after_initialize do
    self.is_api_request = false
  end

  def update_access_token!
    update!(access_token: Digest::SHA256.hexdigest(SecureRandom.uuid)) and return self
  end

  def update_oauth!(oauth)
    provider = oauth[:provider].to_s.downcase.to_sym
    uid = oauth[:uid]

    # 自分以外のユーザーでログインしたSNSと紐付いているならば、ユーザーを削除
    User.where(oauth_provider: provider, oauth_uid: uid).where.not(id: self.id).first&.destroy

    self.update \
      oauth_provider: provider,
      oauth_uid: uid,
      oauth_access_token: oauth[:credentials][:token],
      oauth_access_token_secret: oauth[:credentials][:secret]
    self.update_access_token!
  end

  def to_broadcast_hash
    {
      id: self.id,
      nickname: self.nickname,
      icon_url: self.icon_url,
      icon_thumb_url: self.icon_url(:thumb)
    }
  end

  def self.find_or_create_from_oauth(oauth)
    provider = oauth[:provider].to_s.downcase.to_sym
    uid = oauth[:uid]
    image_url = oauth[:info][:image]

    user = self.find_or_create_by(oauth_provider: provider, oauth_uid: uid) do |user|
      user.nickname = oauth[:info][:name] || oauth[:info][:nickname]
      user.remote_icon_url = image_url if image_url.present?
      user.biography = oauth[:info][:description]
    end

    user.update \
      oauth_access_token: oauth[:credentials][:token],
      oauth_access_token_secret: oauth[:credentials][:secret]
    user
  end

  protected

  def email_required?
    !(persisted? || self.is_api_request || self.oauth_provider.present?)
  end

  def password_required?
    !(persisted? || self.is_api_request || self.oauth_provider.present?)
  end
end
