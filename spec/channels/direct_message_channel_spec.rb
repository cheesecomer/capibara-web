require 'rails_helper'

RSpec.describe DirectMessageChannel, type: :channel do
  let(:user) { FactoryBot.create :user }
  let(:addressee) { FactoryBot.create :user }
  let(:channel) { DirectMessageChannel.new(connection, {}, addressee_id: addressee.id) }
  let(:connection) { TestConnection.new user }

  describe '#subscribed' do
    it do
      expect(channel).to receive(:stream_for).with([connection.current_user, addressee])
      channel.subscribed
    end
  end

  describe '#unsubscribed' do
    it do
      expect(channel).to receive(:stop_all_streams)
      channel.unsubscribed
    end
  end

  describe '#speak' do
    let(:data) { { message: FFaker::Lorem.sentence } }
    it { expect { channel.speak(data) }.to change { DirectMessage.all.count }.by(1) }

    context 'whne follower' do
      let(:number_of_participants) { 10 }
      it do
        addressee.follow_users << user
        expect(DirectMessageChannel).to receive(:broadcast_to).with([addressee, connection.current_user], anything)
        expect(DirectMessageChannel).to receive(:broadcast_to).with([connection.current_user, addressee], anything)
        channel.speak(data)
      end
    end
    context 'when not follower' do
      it do
        expect(DirectMessageChannel).to receive(:broadcast_to).with([addressee, connection.current_user], anything).exactly(0).times
        expect(DirectMessageChannel).to receive(:broadcast_to).with([connection.current_user, addressee], anything)
        channel.speak(data)
      end
    end
  end
end