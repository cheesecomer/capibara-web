
require 'rails_helper'

RSpec.describe TermsController, type: :request do
  describe 'GET #show' do
    subject do
      get terms_url
      response
    end
    it { is_expected.to have_http_status :ok }
  end
end