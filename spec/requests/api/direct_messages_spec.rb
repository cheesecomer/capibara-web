require 'rails_helper'

RSpec.describe 'Blocks', type: :request do
  describe 'GET /api/blocks' do
    subject do
      get api_direct_messages_url, headers: request_header
      response
    end
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json', 'X-ApplicationVersion': '1.0', 'X-Platform': 'test' }.merge optional_header
    end
    context 'when unauthorized' do
      let(:error_response) { { message: I18n.t('devise.failure.unauthenticated') } }
      let(:optional_header) { {} }
      it { is_expected.to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq error_response }
    end
    context 'when empty' do
      let(:user) { FactoryBot.create(:user) }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq direct_messages:[] }
    end
    context 'when not empty' do
      let(:user) { FactoryBot.create(:user) }
      let!(:follows) { FactoryBot.create_list(:follow, 10, owner: user) }
      let!(:direct_messages) { follows.map{|v| FactoryBot.create_list(:direct_message, 10, sender: user, addressee: v.target).map{|v| v } + FactoryBot.create_list(:direct_message, 10, sender: v.target, addressee: user).map{|v| v } } }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq direct_messages:
        direct_messages
          .map { |v| v.last }
          .map.with_index {|v, i|
            {
              content: v.content,
              at: v.created_at.iso8601(3),
              target: {
                id: follows[i].target.id,
                nickname: follows[i].target.nickname,
                icon_thumb_url: follows[i].target.icon_url(:thumb)
              }
            }
          }
          .reverse
        }
    end
  end
end