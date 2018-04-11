
RSpec.describe 'BanDevicesController', type: :request do
  describe 'POST /ban_devices/' do
    subject do
      post ban_devices_path, params: { ban_device: request_body }, headers: { accept: 'application/json' }
      response
    end
    context 'When not signin' do
      let(:request_body) { { device_id: nil } }
      it { is_expected.to have_http_status :unauthorized }
    end
    context 'When signin' do
      let(:admin) { FactoryBot.create(:admin) }
      before { sign_in admin }
      let(:request_body) { { device_id: 'abcd' } }
      it { is_expected.to have_http_status :ok }
    end
  end
end
