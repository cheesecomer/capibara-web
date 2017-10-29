require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  describe 'GET /api/rooms' do
    subject do
      get '/api/rooms', headers: request_header
      response
    end
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json' }.merge optional_header
    end
    let(:error_response) { { message: I18n.t('devise.failure.unauthenticated') } }
    context 'when unauthorized' do
      let(:optional_header) { {} }
      it { expect(subject).to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq error_response }
    end
    context 'when empty' do
      let(:user) { FactoryGirl.create(:user) }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { expect(subject).to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq rooms:[] }
    end
    context 'when not empty' do
      let(:user) { FactoryGirl.create(:user) }
      let!(:rooms) { FactoryGirl.create_list(:room, 10) }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { expect(subject).to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq rooms: rooms.map {|v| v.attributes.symbolize_keys.slice(:id, :name, :capacity).merge number_of_participants: 0 } }
    end
  end

  describe 'GET /api/rooms/#{id}' do
    let!(:room) { FactoryGirl.create(:room) }
    subject do
      get "/api/rooms/#{room.id}", headers: request_header
      response
    end
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json' }.merge optional_header
    end
    let(:error_response) { { message: I18n.t('devise.failure.unauthenticated') } }
    context 'when unauthorized' do
      let(:optional_header) { {} }
      it { expect(subject).to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq error_response }
    end
    context 'when not empty' do
      let(:user) { FactoryGirl.create(:user) }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { expect(subject).to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq id: room.id, name: room.name, capacity: room.capacity, number_of_participants: 0, participants: [], messages: [] }
    end
  end
end