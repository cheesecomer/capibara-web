# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  owner_id   :integer          not null
#  target_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Block < ApplicationRecord
    belongs_to :owner, class_name: 'User'
    belongs_to :target, class_name: 'User'
end
