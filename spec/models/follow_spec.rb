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

require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to(:owner) }
    it { is_expected.to belong_to(:target) }
    it { is_expected.to belong_to(:latest_direct_message) }
  end
end
