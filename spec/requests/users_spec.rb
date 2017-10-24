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
      let(:response_body) { { access_token: user.access_token } }
      it { expect(subject).to have_http_status :ok }
      it { expect { subject }.to change { User.all.count }.by(1) }
      it { expect(JSON.parse(subject.body).deep_symbolize_keys).to eq response_body }
    end
  end
end