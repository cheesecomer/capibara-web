require 'rails_helper'

RSpec.describe ChatChannel, type: :channel do
  let(:user) { FactoryGirl.create :user }
  let(:room) { FactoryGirl.create :room }
  let(:channel) { ChatChannel.new(connection, {}, room_id: room.id) }
  let(:connection) { TestConnection.new user }

  context '#subscribed' do
    it do
      expect(channel).to receive(:stream_from).with("#{ChatChannel.channel_name}:#{room.id}")
      expect(ChatChannel).to receive(:broadcast_to)
      channel.subscribed
    end
  end

  context '#unsubscribed' do
    it do
      expect(ChatChannel).to receive(:broadcast_to)
      channel.unsubscribed
    end
  end

  context '#speak' do
    subject { channel.speak(data) }
    let(:data) { { message: FFaker::Lorem.sentence } }
    it { expect { subject }.to change { Message.all.count }.by(1) }
  end

  describe '.connected_users' do
    let!(:users) { FactoryGirl.create_list :user, 10 }
    subject { ChatChannel.connected_users(room) }
    context 'when connected user nobody' do
      it { is_expected.to be_empty }
    end

    context 'when connected user exists in other channels' do
      let(:rooms) { FactoryGirl.create_list :room, 10 }
      before(:each) do
        connections_statistics =
          users.map do|user|
            {
              identifier: user.access_token,
              subscriptions: [ { channel: ChatChannel.name, room_id: rooms.sample(1).sample.id }.to_json ]
            }
          end
        allow(ActionCable.server).to receive(:open_connections_statistics).and_return(connections_statistics)
      end
      it { is_expected.to be_empty }
    end

    context 'when connected user exists in own channels' do
      before(:each) do
        connections_statistics =
          users.map do|user|
            {
              identifier: user.access_token,
              subscriptions: [ { channel: ChatChannel.name, room_id: room.id }.to_json ]
            }
          end
        allow(ActionCable.server).to receive(:open_connections_statistics).and_return(connections_statistics)
      end
      it { is_expected.to eq users }
    end
  end
end