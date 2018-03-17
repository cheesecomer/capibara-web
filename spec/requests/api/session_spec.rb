require 'rails_helper'

RSpec.describe 'Session', type: :request do
  describe 'POST /api/sessions with email and password' do
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
      let(:response_body) { { access_token: user.access_token, user_id: user.id, user_nickname: user.nickname, user_biography: user.biography } }
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

  describe 'POST /api/sessions with twitter' do
    let!(:twitter) {
      oauth_user = double(Twitter::User)
      allow(oauth_user).to receive(:id).and_return(1)
      allow(oauth_user).to receive(:name).and_return('FooBar')

      client = double(Twitter::REST::Client)
      allow(client).to receive(:user).and_return(oauth_user)

      allow(Twitter::REST::Client).to receive(:new).and_return(client)
    }
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json' }
    end
    let(:error_response) { { message: I18n.t('devise.failure.invalid') } }
    let(:request_json) { { provider: 'twitter', access_token: 'access_token', access_token_secret: 'access_token_secret' }.to_json }
    context 'when twitter user find' do
      subject do
        post '/api/session', params: request_json, headers: request_header
        user.reload
        response
      end
      let!(:user) { FactoryGirl.create(:user, oauth_provider: :twitter, oauth_uid: oauth_uid) }
      let(:oauth_uid) { 1 }
      let(:response_body) { { access_token: user.access_token, user_id: user.id, user_nickname: user.nickname, user_biography: user.biography } }
      it { expect(subject).to have_http_status :ok }
      it { expect { subject }.to change { User.all.count }.by(0) }
      it { expect(JSON.parse(subject.body).symbolize_keys).to eq response_body }
    end

    context 'when twitter user not find' do
      subject do
        post '/api/session', params: request_json, headers: request_header
        response
      end
      let(:oauth_uid) { 10 }
      let(:user) { User.last }
      let(:response_body) { { access_token: user.access_token, user_id: user.id, user_nickname: user.nickname, user_biography: user.biography } }
      it { expect(subject).to have_http_status :ok }
      it { expect { subject }.to change { User.all.count }.by(1) }
      it { expect(JSON.parse(subject.body).deep_symbolize_keys).to eq response_body }
    end
  end
end