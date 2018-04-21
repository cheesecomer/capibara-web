# == Schema Information
#
# Table name: follows
#
#  id                       :integer          not null, primary key
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
end
