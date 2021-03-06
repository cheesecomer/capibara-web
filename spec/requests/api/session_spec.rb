require 'rails_helper'

RSpec.describe 'Session', type: :request do
  describe 'GET /api/sessions' do
    let!(:user) { FactoryBot.create(:user, email: 'user@email.com', password: 'password') }
    subject do
      get '/api/session', headers: request_header
      user.reload
      response
    end
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json', 'X-ApplicationVersion': '1.0', 'X-Platform': 'test' }.merge optional_header
    end
    context 'when unauthorized' do
      let(:optional_header) { {} }
      let(:error_response) { { message: I18n.t('devise.failure.unauthenticated') } }
      it { is_expected.to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq error_response }
    end
    context 'when authorized' do
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      let(:response_body) { { access_token: user.access_token, id: user.id, nickname: user.nickname, biography: user.biography, icon_url: nil, icon_thumb_url: user.icon_url(:thumb), accepted: false, friends_count: 0 } }
      it { is_expected.to have_http_status :ok }
      # it { expect { subject }.to change { user.access_token } }
      it { expect { subject }.to change { user.current_sign_in_at } }
      it { expect(JSON.parse(subject.body).symbolize_keys).to eq response_body }
    end
  end
  describe 'POST /api/sessions' do
    let!(:user) { FactoryBot.create(:user, email: 'user@email.com', password: 'password') }
    subject do
      post '/api/session', params: request_json, headers: request_header
      user.reload
      response
    end
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json', 'X-ApplicationVersion': '1.0', 'X-Platform': 'test' }
    end
    let(:error_response) { { message: I18n.t('devise.failure.invalid') } }
    context 'when email found and valid password' do
      let(:request_json) { { email: 'user@email.com', password: 'password' }.to_json }
      let(:response_body) { { access_token: user.access_token, id: user.id, nickname: user.nickname, biography: user.biography, icon_url: nil, icon_thumb_url: user.icon_url(:thumb), accepted: false, friends_count: 0 } }
      it { is_expected.to have_http_status :ok }
      it { expect { subject }.to change { user.access_token } }
      it { expect { subject }.to change { user.current_sign_in_at } }
      it { expect(JSON.parse(subject.body).symbolize_keys).to eq response_body }
    end

    context 'when email found and invalid password' do
      let(:request_json) { { email: 'user@email.com', password: 'p@ssw0rd' }.to_json }
      it { is_expected.to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body).symbolize_keys).to eq error_response }
    end

    context 'when email not found' do
      let(:request_json) { { email: 'xxx@email.com', password: 'password' }.to_json }
      it { is_expected.to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body).symbolize_keys).to eq error_response }
    end
  end
end