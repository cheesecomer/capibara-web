require 'rails_helper'

RSpec.describe ChatChannel, type: :channel do
  let(:user) { FactoryBot.create :user }
  let(:room) { FactoryBot.create :room, capacity: 10 }
  let(:channel) { ChatChannel.new(connection, {}, room_id: room.id) }
  let(:connection) { TestConnection.new user }

  describe '#subscribed' do
    around do |e|
      travel_to('2010-10-10 10:10'){ e.run }
    end
    let(:join_user_message) do
      {
        id: 0,
        content: {
          type: :join_user,
          user: connection.current_user.to_broadcast_hash,
          number_of_participants: number_of_participants
        }.to_json,
        at: Time.zone.now
      }
    end
    context 'whne empty' do
      let(:number_of_participants) { 0 }
      it do
        allow(ChatChannel).to receive(:connected_users_count).with(room).and_return(0)
        allow(ChatChannel).to receive(:connected_users).with(room).and_return([user])
        expect(channel).to receive(:stream_for).with(room)
        expect(channel).to receive(:stream_for).with([room, connection.current_user])
        expect(ChatChannel).to receive(:broadcast_to).with([room, user], join_user_message)
        channel.subscribed
      end
    end
    context 'whne soon crowded' do
      let(:number_of_participants) { 9 }
      it do
        allow(ChatChannel).to receive(:connected_users_count).with(room).and_return(9)
        allow(ChatChannel).to receive(:connected_users).with(room).and_return([user])
        expect(channel).to receive(:stream_for).with(room)
        expect(channel).to receive(:stream_for).with([room, connection.current_user])
        expect(ChatChannel).to receive(:broadcast_to).with([room, user], join_user_message)
        channel.subscribed
      end
    end
    context 'when crowded' do
      it do
        allow(ChatChannel).to receive(:connected_users_count).with(room).and_return(10)
        allow(ChatChannel).to receive(:connected_users).with(room).and_return([user])
        expect(channel).to receive(:reject_subscription)
        expect(channel).not_to receive(:stream_for)
        expect(ChatChannel).not_to receive(:broadcast_to)
        channel.subscribed
      end
    end
  end

  describe '#unsubscribed' do
    around do |e|
      travel_to('2010-10-10 10:10'){ e.run }
    end
    let(:leave_user_message) do
      {
        id: 0,
        content: {
          type: :leave_user,
          user: connection.current_user.to_broadcast_hash,
          number_of_participants: 0
        }.to_json,
        at: Time.zone.now
      }
    end
    it do
      allow(ChatChannel).to receive(:connected_users).with(room).and_return([user])
      expect(ChatChannel).to receive(:broadcast_to).with([room, user], leave_user_message)
      channel.unsubscribed
    end
  end

  describe '#speak' do
    subject { channel.speak(data) }
    let(:data) { { message: FFaker::Lorem.sentence } }
    it { expect { subject }.to change { Message.all.count }.by(1) }
  end

  describe '.connected_users' do
    let!(:users) { FactoryBot.create_list :user, 10 }
    subject { ChatChannel.connected_users(room) }
    context 'when connected user nobody' do
      it { is_expected.to be_empty }
    end

    context 'when connected user exists in other channels' do
      let(:rooms) { FactoryBot.create_list :room, 10 }
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

  describe '.connected_users_count' do
    let!(:users) { FactoryBot.create_list :user, 10 }
    subject { ChatChannel.connected_users_count(room) }
    context 'when connected user nobody' do
      it { is_expected.to eq 0 }
    end

    context 'when connected user exists in other channels' do
      let(:rooms) { FactoryBot.create_list :room, 10 }
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
      it { is_expected.to eq 0 }
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
      it { is_expected.to eq 10 }
    end
  end
end