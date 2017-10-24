# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  sender_id  :integer
#  room_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
  describe '#sender' do
    it { is_expected.to validate_presence_of(:sender) }
  end
  describe '#room' do
    it { is_expected.to validate_presence_of(:room) }
  end
  describe '#create' do
    let(:message) { FactoryGirl.build(:message) }
    subject { message.save }
    context 'when valid' do
      it 'when valid should execute MessageBroadcastJob.perform_later' do
        expect(MessageBroadcastJob).to receive(:perform_later).with(message)
        subject
      end
    end
  end
end
