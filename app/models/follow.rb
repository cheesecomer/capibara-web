# == Schema Information
#
# Table name: follows
#
#  id         :integer          not null, primary key
#  owner_id   :integer          not null
#  target_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Follow < ApplicationRecord
end
