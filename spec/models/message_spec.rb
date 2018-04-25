# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  content    :text(65535)
#  sender_id  :integer
#  room_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image      :string(255)
#

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to(:sender) }
    it { is_expected.to belong_to(:room) }
  end
  describe '#content' do
    it { is_expected.to validate_presence_of(:content) }
  end
  describe '#image' do
    it { is_expected.to validate_presence_of(:image) }
  end
  describe '#sender' do
    it { is_expected.to validate_presence_of(:sender) }
  end
  describe '#room' do
    it { is_expected.to validate_presence_of(:room) }
  end
  describe '#to_broadcast_hash' do
    let(:message) { FactoryBot.create(:message) }
    subject { message.to_broadcast_hash }
    context 'when valid' do
      it do
        is_expected.to eq(
          {
            id: message.id,
            content: message.content,
            image_url: nil,
            image_thumb_url: nil,
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
