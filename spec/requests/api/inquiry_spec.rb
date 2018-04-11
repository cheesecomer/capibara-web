require 'rails_helper'

RSpec.describe 'Inquiries', type: :request do
  describe 'POST /api/inquiries' do
    subject do
      post '/api/inquiries', params: request_json, headers: request_header
      response
    end
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json', 'X-ApplicationVersion': '1.0', 'X-Platform': 'test' }.merge optional_header
    end
    let(:target) { FactoryBot.create(:user) }
    context 'when unauthorized' do
      let(:optional_header) { {} }
      let(:error_response) { { message: I18n.t('devise.failure.unauthenticated') } }
      let(:request_json) { { target_id: target.id }.to_json }
      it { is_expected.to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq error_response }
    end
    context 'when authorized' do
      let(:user) { FactoryBot.create(:user) }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      let(:request_json) { { email: FFaker::Internet.email, content: FFaker::LoremJA.sentence }.to_json }
      it { is_expected.to have_http_status :no_content }
      it { expect { subject }.to change { Inquiry.all.count }.by(1) }
    end
  end
end