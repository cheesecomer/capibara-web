require 'rails_helper'

RSpec.describe RoomsController, type: :request do
  describe 'GET #index' do
    subject do
      get rooms_url
      response
    end
    context 'When not signin' do
      it { is_expected.to have_http_status :found }
    end
    context 'When signin' do
      let(:admin) { FactoryBot.create(:admin) }
      before { sign_in admin }
      it { is_expected.to have_http_status :ok }
      it 'when valid should execute order by priority' do
        expect(Room).to receive(:order).with(:priority).and_return(Room.all)
        subject
      end
    end
  end
  describe 'POST /rooms' do
    subject do
      post rooms_url, params: { room: request_body }, headers: { accept: 'application/json' }
      response
    end
    context 'When not signin' do
      let(:request_body) { { name: nil } }
      it { is_expected.to have_http_status :unauthorized }
    end
    context 'When invalid' do
      let(:admin) { FactoryBot.create(:admin) }
      before { sign_in admin }
      let(:request_body) { { name: nil } }
      it { is_expected.to have_http_status 422 }
    end
    context 'When valid' do
      let(:admin) { FactoryBot.create(:admin) }
      before { sign_in admin }
      let(:request_body) { { name: Precure.map(&:title).sample, capacity: 10, priority: 1 } }
      it { is_expected.to have_http_status :ok }
    end
  end

  describe 'PUT /rooms/id' do
    let(:room) { FactoryBot.create :room }
    subject do
      put room_url(room), params: { room: request_body }, headers: { accept: 'application/json' }
      response
    end
    context 'When not signin' do
      let(:request_body) { { name: nil } }
      it { is_expected.to have_http_status :unauthorized }
    end
    context 'When invalid' do
      let(:admin) { FactoryBot.create(:admin) }
      before { sign_in admin }
      let(:request_body) { { name: nil } }
      it { is_expected.to have_http_status 422 }
    end
    context 'When valid' do
      let(:admin) { FactoryBot.create(:admin) }
      before { sign_in admin }
      let(:request_body) { { name: Precure.map(&:title).sample, capacity: 10, priority: 1 } }
      it { is_expected.to have_http_status :ok }
    end
  end
end