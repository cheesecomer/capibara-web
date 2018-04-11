require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe '#index' do
    subject do
      get users_url
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
    end
  end
  describe '#destroy' do
    let!(:user) { FactoryBot.create(:user) }
    subject do
      delete user_url(user)
      response
    end
    context 'When not signin' do
      it { is_expected.to have_http_status :found }
    end
    context 'When signin' do
      let(:admin) { FactoryBot.create(:admin) }
      before { sign_in admin }
      it { is_expected.to have_http_status :no_content }
      it { expect { subject }.to change { User.all.count }.by(-1) }
    end
  end
end