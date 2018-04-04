require 'rails_helper'

RSpec.describe DashboardsController, type: :request do
  describe 'GET #show' do
    subject do
      get dashboard_url
      response
    end
    context 'When not signin' do
      it { is_expected.to have_http_status :found }
    end
    context 'When signin' do
      let(:admin) { FactoryBot.create(:admin) }
      before { sign_in admin }
      it { is_expected.to have_http_status :ok }
    end
  end
end