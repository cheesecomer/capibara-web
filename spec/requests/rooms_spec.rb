require 'rails_helper'

RSpec.describe RoomsController, type: :request do
  describe 'GET #index' do
    subject do
      get rooms_url
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
        expect(Room).to receive(:order).with(:priority).and_return(Room.all)
        subject
      end
    end
  end
end