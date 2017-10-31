require 'rails_helper'

RSpec.describe 'Session', type: :request do
  describe 'POST /api/sessions' do
    let!(:user) { FactoryGirl.create(:user, email: 'user@email.com', password: 'password') }
    subject do
      post '/api/session', params: request_json, headers: request_header
      user.reload
      response
    end
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json' }
    end
    let(:error_response) { { message: I18n.t('devise.failure.invalid') } }
    context 'when email found and valid password' do
      let(:request_json) { { email: 'user@email.com', password: 'password' }.to_json }
      let(:response_body) { { access_token: user.access_token, user_id: user.id } }
      it { expect(subject).to have_http_status :ok }
      it { expect { subject }.to change { user.access_token } }
      it { expect { subject }.to change { user.current_sign_in_at } }
      it { expect(JSON.parse(subject.body).symbolize_keys).to eq response_body }
    end

    context 'when email found and invalid password' do
      let(:request_json) { { email: 'user@email.com', password: 'p@ssw0rd' }.to_json }
      it { expect(subject).to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body).symbolize_keys).to eq error_response }
    end

    context 'when email not found' do
      let(:request_json) { { email: 'xxx@email.com', password: 'password' }.to_json }
      it { expect(subject).to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body).symbolize_keys).to eq error_response }
    end
  end
end