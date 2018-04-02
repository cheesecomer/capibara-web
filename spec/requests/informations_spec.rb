require 'rails_helper'

RSpec.describe InformationsController, type: :request do
  describe 'GET #index' do
    subject do
      get informations_url
      response
    end
    context 'When not signin' do
      it { is_expected.to have_http_status :found }
    end
    context 'When signin' do
      let(:admin) { FactoryBot.create(:admin) }
      before { sign_in admin }
      it { is_expected.to have_http_status :ok }
      it { is_expected.to render_template(locals: :index, layout: :admin) }
      it 'when valid should execute order by published_at desc' do
        expect(Information).to receive(:order).with(published_at: :desc).and_return(Information.all)
        subject
      end
    end
  end

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