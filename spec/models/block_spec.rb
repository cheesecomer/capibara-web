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

require 'rails_helper'

RSpec.describe Block, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
