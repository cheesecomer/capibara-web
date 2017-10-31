require 'rails_helper'

RSpec.describe 'RoomsController', type: :request do
  describe 'GET /rooms' do
    subject do
      get '/rooms'
      response
    end
    context 'When not signin' do
      it { expect(subject).to have_http_status :found }
    end
    context 'When signin' do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      it { expect(subject).to have_http_status :ok }
    end
  end

  describe 'GET /rooms/#{id}' do
    subject do
      get "/rooms/#{room_id}"
      response
    end
    context 'When not signin' do
      let(:room_id) { FactoryGirl.create(:room).id }
      it { expect(subject).to have_http_status :found }
    end
    context 'When not found' do
      let(:user) { FactoryGirl.create(:user) }
      let(:room_id) { 0 }
      before { sign_in user }
      it { expect(subject).to have_http_status :not_found }
    end
    context 'When found' do
      let(:user) { FactoryGirl.create(:user) }
      let(:room_id) { FactoryGirl.create(:room).id }
      before { sign_in user }
      it { expect(subject).to have_http_status :ok }
    end
  end
end