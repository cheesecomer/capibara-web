require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /api/users' do
    subject do
      post '/api/users', params: request_json, headers: request_header
      response
    end
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json' }
    end
    context 'When nickname is empty' do
      let(:request_json) { { nickname: '' }.to_json }
      let(:response_body) {
        {
          message: I18n.t('api.errors.invalid_request'),
          errors:[
            {
              attribute: 'nickname',
              message: I18n.t(
                'errors.format',
                attribute: User.human_attribute_name(:nickname),
                message: I18n.t('errors.messages.blank'))
            }
          ]
        }
      }
      it { expect(subject).to have_http_status :unprocessable_entity }
      it { expect { subject }.to_not change { User.all.count } }
      it { expect(JSON.parse(subject.body).deep_symbolize_keys).to eq response_body }
    end
    context 'When nickname is presence' do
      let(:request_json) { { nickname: FFaker::Name.name }.to_json }
      let(:user) { User.last }
      let(:response_body) { { access_token: user.access_token, id: user.id, nickname: user.nickname, biography: user.biography, icon_url: nil, accepted: false } }
      it { expect(subject).to have_http_status :ok }
      it { expect { subject }.to change { User.all.count }.by(1) }
      it { expect(JSON.parse(subject.body).deep_symbolize_keys).to eq response_body }
    end
  end

  describe 'GET /api/users/#{id}' do
    let(:user) { FactoryBot.create(:user) }
    subject do
      get "/api/users/#{user.id}", headers: request_header
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
      let(:signin_user) { FactoryBot.create(:user) }
      let(:optional_header) { { authorization: "Token #{signin_user.access_token}" } }
      it { expect(subject).to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq id: user.id, nickname: user.nickname, biography: user.biography, icon_url: user.icon_url, is_block: false }
    end
    context 'when is block' do
      let(:signin_user) { FactoryBot.create(:user) }
      let(:optional_header) { { authorization: "Token #{signin_user.access_token}" } }
      let!(:block) { FactoryBot.create(:block, owner: signin_user, target: user) }
      it { expect(subject).to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq id: user.id, nickname: user.nickname, biography: user.biography, icon_url: user.icon_url, is_block: true }
    end
    context 'when myself' do
      let(:signin_user) { user }
      let(:optional_header) { { authorization: "Token #{signin_user.access_token}" } }
      let!(:block) { FactoryBot.create(:block, owner: signin_user, target: user) }
      it { expect(subject).to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq id: user.id, nickname: user.nickname, biography: user.biography, icon_url: user.icon_url, accepted: false }
    end
  end

  describe 'PUT /api/users/' do
    let!(:user) { FactoryBot.create(:user) }
    subject do
      put "/api/users/", params: params.to_json, headers: request_header
      response
    end
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json' }.merge optional_header
    end
    let(:error_response) { { message: I18n.t('devise.failure.unauthenticated') } }
    context 'when unauthorized' do
      let(:optional_header) { {} }
      let(:params) { { nickname: '' } }
      it { expect(subject).to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq error_response }
    end
    context 'When nickname is empty' do
      let(:params) { { nickname: '' } }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      let(:response_body) {
        {
          message: I18n.t('api.errors.invalid_request'),
          errors:[
            {
              attribute: 'nickname',
              message: I18n.t(
                'errors.format',
                attribute: User.human_attribute_name(:nickname),
                message: I18n.t('errors.messages.blank'))
            }
          ]
        }
      }
      it { expect(subject).to have_http_status :unprocessable_entity }
      it { expect { subject }.to_not change { User.all.count } }
      it { expect(JSON.parse(subject.body).deep_symbolize_keys).to eq response_body }
    end
    context 'When nickname is presence' do
      let(:params) { { nickname: FFaker::Name.name, biography: FFaker::LoremJA.paragraph } }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      let(:response_body) { { id: user.id, nickname: params[:nickname], biography: params[:biography], icon_url: user.icon_url, accepted: false } }
      it { expect(subject).to have_http_status :ok }
      it { expect { subject }.to_not change { User.all.count } }
      it { expect(JSON.parse(subject.body).deep_symbolize_keys).to eq response_body }
    end
    context 'When accepted' do
      let(:params) { { nickname: FFaker::Name.name, biography: FFaker::LoremJA.paragraph, accepted: true } }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      let(:response_body) { { id: user.id, nickname: params[:nickname], biography: params[:biography], icon_url: user.icon_url, accepted: true } }
      it { expect(subject).to have_http_status :ok }
      it { expect { subject }.to_not change { User.all.count } }
      it { expect(JSON.parse(subject.body).deep_symbolize_keys).to eq response_body }
    end
  end

  describe 'DELETE /api/users/' do
    subject do
      delete "/api/users/", headers: request_header
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
    context 'when logined' do
      let(:signin_user) { FactoryBot.create(:user) }
      let(:optional_header) { { authorization: "Token #{signin_user.access_token}" } }
      it { expect(subject).to have_http_status :no_content }
    end
  end
end