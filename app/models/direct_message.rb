# == Schema Information
#
# Table name: direct_messages
#
#  id           :integer          not null, primary key
#  addressee_id :integer          not null
#  sender_id    :integer          not null
#  content      :text(65535)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class DirectMessage < ApplicationRecord
  belongs_to :addressee, class_name: 'User'
  belongs_to :sender, class_name: 'User'
end
