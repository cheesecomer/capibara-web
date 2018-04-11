
require 'rails_helper'

RSpec.describe WelcomsController, type: :request do
  describe 'GET #show' do
    subject do
      get welcom_url
      response
    end
    it { is_expected.to have_http_status :ok }
  end
end