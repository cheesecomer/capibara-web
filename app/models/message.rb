# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  sender_id  :integer
#  room_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :room

  after_create_commit { MessageBroadcastJob.perform_later self }

  # --------------------------------------------------------------------------
  # Validations
  # --------------------------------------------------------------------------
  validates :content, presence: true

  def to_broadcast_hash
    {
      id: self.id,
      content: self.content,
      sender: {
        id: self.sender.id,
        nickname: self.sender.nickname,
        icon_url: self.sender.icon_url
      },
      at: self.created_at
    }
  end
end
