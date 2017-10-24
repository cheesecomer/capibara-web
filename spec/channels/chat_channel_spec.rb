require 'rails_helper'

RSpec.describe ChatChannel, type: :channel do
  let(:user) { FactoryGirl.create :user }
  let(:room) { FactoryGirl.create :room }
  let(:channel) { ChatChannel.new(connection, {}, room_id: room.id) }
  let(:connection) { TestConnection.new user }

  context '#subscribed' do
    it do
      expect(channel).to receive(:stream_from).with("#{ChatChannel.channel_name}:#{room.id}")
      channel.subscribed
    end
  end

  context '#speak' do
    subject { channel.speak(data) }
    let(:data) { { message: FFaker::Lorem.sentence } }
    it { expect { subject }.to change { Message.all.count }.by(1) }
  end

  context '.connected_user' do
  end
end