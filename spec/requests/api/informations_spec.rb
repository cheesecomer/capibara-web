require 'rails_helper'

RSpec.describe 'Informations', type: :request do
  describe 'GET /api/informations' do
    subject do
      get '/api/informations', headers: request_header
      response
    end
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json', 'X-ApplicationVersion': '1.0', 'X-Platform': 'test' }.merge optional_header
    end
    context 'when unauthorized' do
      let(:error_response) { { message: I18n.t('devise.failure.unauthenticated') } }
      let(:optional_header) { {} }
      it { is_expected.to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq error_response }
    end
    context 'when empty' do
      let(:user) { FactoryBot.create(:user) }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq informations: [] }
    end
    context 'when not empty' do
      let(:user) { FactoryBot.create(:user) }
      let!(:informations) { (1..10).to_a.map{|i| FactoryBot.create(:information, published_at: i.day.ago) } }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq informations: informations.map {|v| { id: v.id, title: v.title, message: v.message, published_at: v.published_at.iso8601(3), url: information_url(v) } } }
    end
  end
end