# == Schema Information
#
# Table name: direct_messages
#
#  id           :bigint(8)        not null, primary key
#  addressee_id :integer          not null
#  sender_id    :integer          not null
#  content      :text(65535)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class DirectMessage < ApplicationRecord
  belongs_to :addressee, class_name: 'User'
  belongs_to :sender, class_name: 'User'
  has_many :follows, foreign_key: :latest_direct_message_id

  after_create_commit {
    Follow.where(owner: sender, target: addressee).take&.update(latest_direct_message: self)
    Follow.where(owner: addressee, target: sender).take&.update(latest_direct_message: self)
  }

  def to_broadcast_hash
    {
      id: self.id,
      content: self.content,
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
