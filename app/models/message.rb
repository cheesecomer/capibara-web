# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  content    :text(65535)
#  sender_id  :integer
#  room_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image      :string(255)
#

class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :room

  mount_base64_uploader :image, ImageUploader

  # --------------------------------------------------------------------------
  # Validations
  # --------------------------------------------------------------------------
  validates :content, presence: true, if: -> { image.blank? }
  validates :image, presence: true, if: -> { content.blank? }

  def to_broadcast_hash
    {
      id: self.id,
      content: self.content,
      image_url: self.image_url,
      image_thumb_url: self.image_url(:thumb),
      sender: {
        id: self.sender.id,
        nickname: self.sender.nickname,
        icon_url: self.sender.icon_url,
        icon_thumb_url: self.sender.icon_url(:thumb)
      },
      at: self.created_at
    }
  end
end
