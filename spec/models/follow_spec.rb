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

require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to(:owner) }
    it { is_expected.to belong_to(:target) }
  end
end
