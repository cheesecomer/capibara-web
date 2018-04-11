require 'rails_helper'

RSpec.describe ReportsController, type: :request do
  describe 'GET #index' do
    subject do
      get reports_url
      response
    end
    context 'When not signin' do
      it { is_expected.to have_http_status :found }
    end
    context 'When signin' do
      let(:admin) { FactoryBot.create(:admin) }
      before { sign_in admin }
      it { is_expected.to have_http_status :ok }
      it 'when valid should execute order by priority' do
        expect(Report).to receive_message_chain(:includes ,:order).with(:sender, :target).with(:created_at).and_return(Report.all)
        subject
      end
    end
  end
end