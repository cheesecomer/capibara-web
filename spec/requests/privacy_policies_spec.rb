
require 'rails_helper'

RSpec.describe PrivacyPoliciesController, type: :request do
  describe 'GET #show' do
    subject do
      get privacy_policy_url
      response
    end
    it { is_expected.to have_http_status :ok }
  end
end