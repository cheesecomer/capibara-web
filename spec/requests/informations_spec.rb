require 'rails_helper'

RSpec.describe InformationsController, type: :request do
  describe 'GET #show' do
    subject do
      get information_url information
      response
    end
    let(:information) { FactoryBot.create(:information, published_at: published_at) }
    context 'when future' do
      let(:published_at) { 1.days.since }
      it { is_expected.to have_http_status :not_found }
    end
    context 'when past' do
      let(:published_at) { 1.days.ago }
      it { is_expected.to have_http_status :ok }
    end
  end
end