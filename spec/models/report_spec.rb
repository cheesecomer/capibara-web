# == Schema Information
#
# Table name: reports
#
#  id         :bigint(8)        not null, primary key
#  sender_id  :integer          not null
#  target_id  :integer          not null
#  reason     :integer          not null
#  message    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Report, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to(:sender) }
    it { is_expected.to belong_to(:target) }
  end
  describe '#message' do
    context 'when reason is other' do
      it { expect(Report.new(reason: :other)).to validate_presence_of(:message) }
    end
  end
end
