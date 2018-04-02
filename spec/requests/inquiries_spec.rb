require 'rails_helper'

RSpec.describe InquiriesController, type: :request do
  describe 'GET /inquiries' do
    subject do
      get inquiries_url
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
      it 'when valid should execute order by priority' do
        expect(Inquiry).to receive_message_chain(:includes, :order).with(:sender).with(:created_at).and_return(Inquiry.all)
        subject
      end
    end
  end

  describe 'GET /inquiries/new' do
    subject do
      get new_inquiry_url
      response
    end
    it { is_expected.to have_http_status :ok }
  end

  describe 'POST /inquiries' do
    subject do
      post inquiries_url, params: { inquiry: request_body }
      response
    end
    context 'When valie' do
      let(:request_body) { { name: nil } }
      it { is_expected.to have_http_status :ok }
      it { is_expected.to render_template(locals: :create, layout: :public) }
    end
    context 'When invalie' do
      let(:request_body) { { name: Precure.all.sample[:precure_name], email: FFaker::Internet.email, content: FFaker::LoremJA.sentence } }
      it { is_expected.to have_http_status :ok }
      it { is_expected.to render_template(locals: :new, layout: :public) }
    end
  end
end