require 'rails_helper'

RSpec.describe 'Oath', type: :request do
  describe 'GET /api/oauth/:provider/callback' do
    subject do
      get "/api/oauth/#{provider}#{query}"
      get response.location
      response
    end

    let! (:user) { FactoryBot.create(:user) }
    let (:provider) { :twitter }

    context 'when hasnt user id' do
      before { allow(User).to receive(:find_or_create_from_oauth).and_return(user) }
      let (:query) { }
      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to "com.cheesecomer.capibara://oauth?access_token=#{user.access_token}&id=#{user.id}" }
    end

    context 'when has user id' do
      before { allow_any_instance_of(User).to receive(:update_oauth!).and_return(user) }
      let (:query) { "?user_id=#{user.id}&access_token=#{user.access_token}" }
      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to "com.cheesecomer.capibara://oauth?access_token=#{user.access_token}&id=#{user.id}" }
    end
  end
end