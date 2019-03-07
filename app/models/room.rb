# == Schema Information
#
# Table name: rooms
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)
#  capacity   :integer          not null
#  priority   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#

class Room < ApplicationRecord
  acts_as_paranoid

  validates :name, presence: true

  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validates :priority, presence: true, numericality: { only_integer: true, greater_than: 0 }

  has_many :messages, dependent: :destroy

  def participants
    channel_prefix = ActionCable.server.pubsub.send(:channel_with_prefix, ChatChannel.channel_name)
    Redis.new.pubsub("channels", "#{channel_prefix}:*")
      .map {|v| v.split(':').drop(2).map{|c| Base64.decode64(c) } }
      .select {|v| v.length == 2 }.select {|v| v[0] == self.to_global_id.to_s }
      .select {|v| v[1] =~ /^gid:\/\/capibara\/User\/[0-9]{1,}$/ }
      .map {|v| v[1].split('/').last.to_i }
      .tap{|v| break User.where(id: v) }
  end
end
