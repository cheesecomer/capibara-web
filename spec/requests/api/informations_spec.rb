require 'rails_helper'

RSpec.describe 'Informations', type: :request do
  describe 'GET /api/informations' do
    subject do
      get '/api/informations', headers: request_header
      response
    end
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json' }.merge optional_header
    end
    context 'when unauthorized' do
      let(:error_response) { { message: I18n.t('devise.failure.unauthenticated') } }
      let(:optional_header) { {} }
      it { expect(subject).to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq error_response }
    end
    context 'when empty' do
      let(:user) { FactoryGirl.create(:user) }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { expect(subject).to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq informations: [] }
    end
    context 'when not empty' do
      let(:user) { FactoryGirl.create(:user) }
      let!(:informations) { FactoryGirl.create_list(:information, 10) }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { expect(subject).to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq informations: informations.map {|v| { id: v.id, title: v.title, message: v.message, published_at: v.published_at.iso8601(3) } } }
    end
  end
end