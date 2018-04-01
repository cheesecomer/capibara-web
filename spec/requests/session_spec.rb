require 'rails_helper'

RSpec.describe 'SessionsController', type: :request do
  describe 'GET /session/new' do
    subject do
      get '/session/new'
      response
    end
    context 'When not signin' do
      it { is_expected.to have_http_status :ok }
    end
    context 'When signin' do
      let(:admin) { FactoryBot.create(:admin) }
      before { sign_in admin }
      it { is_expected.to have_http_status :found }
    end
  end

  describe 'POST /session' do
    let(:admin) { FactoryBot.create(:admin) }
    subject do
      post '/session', params: { admin: request_body }
      response
    end
    context 'When valie' do
      let(:request_body) { { email: admin.email, password: 'password' } }
      it { is_expected.to have_http_status :found }
    end
    context 'When invalie' do
      let(:request_body) { { email: admin.email, password: 'xxxxxxxx' } }
      it { is_expected.to have_http_status :ok }
    end
    context 'When signin' do
      let(:request_body) { { email: admin.email, password: 'password' } }
      before { sign_in admin }
      it { is_expected.to have_http_status :found }
    end
  end
end