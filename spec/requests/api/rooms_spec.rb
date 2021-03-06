require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  describe 'GET /api/rooms' do
    subject do
      get '/api/rooms', headers: request_header
      response
    end
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json', 'X-ApplicationVersion': '1.0', 'X-Platform': 'test' }.merge optional_header
    end
    let(:error_response) { { message: I18n.t('devise.failure.unauthenticated') } }
    context 'when unauthorized' do
      let(:optional_header) { {} }
      it { is_expected.to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq error_response }
    end
    context 'when empty' do
      let(:user) { FactoryBot.create(:user) }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq rooms:[] }
    end
    context 'when not empty' do
      let(:user) { FactoryBot.create(:user) }
      let!(:rooms) { (1..10).map{ |v| v }.reverse.map {|v| FactoryBot.create(:room, priority: v) } }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq rooms: rooms.reverse.map {|v| v.attributes.symbolize_keys.slice(:id, :name, :capacity).merge number_of_participants: 0 } }
    end
  end

  describe 'GET /api/rooms/#{id}' do
    let!(:room) { FactoryBot.create(:room) }
    subject do
      get "/api/rooms/#{room.id}", headers: request_header
      response
    end
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json', 'X-ApplicationVersion': '1.0', 'X-Platform': 'test' }.merge optional_header
    end
    let(:error_response) { { message: I18n.t('devise.failure.unauthenticated') } }
    context 'when unauthorized' do
      let(:optional_header) { {} }
      it { is_expected.to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq error_response }
    end
    context 'when not empty' do
      let(:user) { FactoryBot.create(:user) }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq id: room.id, name: room.name, capacity: room.capacity, number_of_participants: 0, participants: [], messages: [] }
    end
    context 'when has blockuser message' do
      let(:user) { FactoryBot.create(:user) }
      let(:block) { FactoryBot.create(:block, owner: user) }
      let!(:message) { FactoryBot.create(:message, sender: block.target, room: room)}
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq id: room.id, name: room.name, capacity: room.capacity, number_of_participants: 0, participants: [], messages: [] }
    end
    context 'when block' do
      let(:user) { FactoryBot.create(:user) }
      let(:block) { FactoryBot.create(:block, target: user) }
      let!(:message) { FactoryBot.create(:message, sender: block.owner, room: room)}
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq id: room.id, name: room.name, capacity: room.capacity, number_of_participants: 0, participants: [], messages: [] }
    end
    context 'when has not blockuser message' do
      let(:user) { FactoryBot.create(:user) }
      let(:block) { FactoryBot.create(:block) }
      let!(:message) { FactoryBot.create(:message, sender: block.owner, room: room)}
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq id: room.id, name: room.name, capacity: room.capacity, number_of_participants: 0, participants: [], messages: [
        { sender: { id: message.sender.id, nickname: message.sender.nickname, icon_url: message.sender.icon_url, icon_thumb_url: message.sender.icon_url(:thumb) }, id: message.id, content: message.content, image_url: nil, image_thumb_url: nil, at: message.created_at.iso8601(3) }] }
    end
    context 'when deleted' do
      let(:user) { FactoryBot.create(:user) }
      let(:other_user) { FactoryBot.create(:user).destroy }
      let!(:message) { FactoryBot.create(:message, sender: other_user, room: room)}
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq id: room.id, name: room.name, capacity: room.capacity, number_of_participants: 0, participants: [], messages: [ ] }
    end
  end
end