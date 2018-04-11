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
  describe "Associations" do
    it { is_expected.to belong_to(:owner) }
    it { is_expected.to belong_to(:target) }
  end
end
