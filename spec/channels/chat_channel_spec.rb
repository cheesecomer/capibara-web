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
      let(:number_of_participants) { 1 }
      it do
        expect(channel).to receive(:stream_for).with(room)
        expect(channel).to receive(:stream_for).with([room, connection.current_user])
        expect(ChatChannel).to receive(:broadcast_to).with([room, connection.current_user], join_user_message)
        channel.subscribed
      end
    end
    context 'whne soon crowded' do
      let!(:participants) { FactoryBot.create_list(:participant, 9, room: room) }
      let(:number_of_participants) { 10 }
      it do
        expect(channel).to receive(:stream_for).with(room)
        expect(channel).to receive(:stream_for).with([room, connection.current_user])
        expect(ChatChannel).to receive(:broadcast_to).with([room, anything], join_user_message).exactly(10).times
        channel.subscribed
      end
    end
    context 'whne full' do
      let!(:participants) { FactoryBot.create_list(:participant, 10, room: room) }
      it do
        expect(channel).to receive(:reject_subscription)
        expect(channel).not_to receive(:stream_for)
        expect(ChatChannel).not_to receive(:broadcast_to)
        channel.subscribed
      end
    end
    context 'when crowded' do
      let!(:participants) { FactoryBot.create_list(:participant, 11, room: room) }
      it do
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
      channel.subscribed
      channel.unsubscribed
    end
  end

  describe '#speak' do
    subject { channel.speak(data) }
    let(:data) { { message: FFaker::Lorem.sentence } }
    it { expect { subject }.to change { Message.all.count }.by(1) }
  end
end