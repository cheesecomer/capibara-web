require 'rails_helper'

RSpec.describe 'Oath', type: :request do
  describe 'GET /api/oauth/:provider/callback' do
    subject do
      allow(User).to receive(:find_or_create_from_oauth).and_return(user)
      get "/api/oauth/#{provider}/callback"
      response
    end
    context 'when twitter' do
      let (:provider) { :twitter }
      let (:user) { FactoryBot.create(:user) }
      it { expect(subject).to have_http_status :found }
      it { expect(subject).to redirect_to "com.cheesecomer.capibara://oauth?access_token=#{user.access_token}&id=#{user.id}" }
    end
  end
end