# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
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
    ActionCable.server.connections.select { |v| v.identifier == self.id }.map{|v| v.current_user }
  end
end
