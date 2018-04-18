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

require 'rails_helper'

RSpec.describe DirectMessage, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to(:addressee) }
    it { is_expected.to belong_to(:sender) }
  end
  describe '#to_broadcast_hash' do
    let(:message) { FactoryBot.create(:direct_message) }
    subject { message.to_broadcast_hash }
    context 'when valid' do
      it do
        is_expected.to eq(
          {
            id: message.id,
            content: message.content,
            sender: {
              id: message.sender.id,
              nickname: message.sender.nickname,
              icon_url: nil,
              icon_thumb_url: nil
            },
            at: message.created_at
          }
        )
      end
    end
  end
end
