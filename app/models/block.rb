# == Schema Information
#
# Table name: blocks
#
#  id         :bigint(8)        not null, primary key
#  owner_id   :integer          not null
#  target_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Block < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  belongs_to :target, class_name: 'User'
  after_create_commit {
    Follow.where(owner: owner, target: target).destroy_all
  }
end
