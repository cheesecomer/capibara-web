# == Schema Information
#
# Table name: follows
#
#  id                       :bigint(8)        not null, primary key
#  owner_id                 :integer          not null
#  target_id                :integer          not null
#  latest_direct_message_id :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class Follow < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  belongs_to :target, class_name: 'User'
  belongs_to :latest_direct_message, class_name: 'DirectMessage', optional: true
  before_create {
    self.latest_direct_message_id =
      DirectMessage.where(sender: owner, addressee: target)
        .or(DirectMessage.where(sender: target, addressee: owner)).last&.id
  }
end
