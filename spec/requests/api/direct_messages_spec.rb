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
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq threads:[] }
    end
    context 'when not empty' do
      let(:user) { FactoryBot.create(:user) }
      let!(:follows) { FactoryBot.create_list(:follow, 10, owner: user) }
      let!(:direct_messages) { follows.map{|v| FactoryBot.create_list(:direct_message, 10, sender: user, addressee: v.target).map{|v| v } + FactoryBot.create_list(:direct_message, 10, sender: v.target, addressee: user).map{|v| v } } }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq threads:
        direct_messages
          .map { |v| v.last }
          .map.with_index {|v, i|
            {
              content: v.content,
              at: v.created_at.iso8601(3),
              user: {
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
  describe 'GET /api/blocks' do
    let(:target) { FactoryBot.create(:user) }
    let(:last_id) { nil }
    subject do
      get api_direct_message_url(id: target.id, last_id: last_id), headers: request_header
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
      let!(:direct_messages) { (1..10).map{ [FactoryBot.create(:direct_message, sender: user, addressee: target), FactoryBot.create(:direct_message, sender: target, addressee: user)] }.flatten }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq direct_messages:
        direct_messages
          .map {|v, i|
            {
              id: v.id,
              content: v.content,
              at: v.created_at.iso8601(3),
              sender: {
                id: v.sender.id,
                nickname: v.sender.nickname,
                icon_url: v.sender.icon_url,
                icon_thumb_url: v.sender.icon_url(:thumb)
              }
            }
          }
        }
    end
    context 'when over 50 hasnt id' do
      let(:user) { FactoryBot.create(:user) }
      let!(:direct_messages) { (1..30).map{ [FactoryBot.create(:direct_message, sender: user, addressee: target), FactoryBot.create(:direct_message, sender: target, addressee: user)] }.flatten }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq direct_messages:
        direct_messages
          .drop(10)
          .map {|v, i|
            {
              id: v.id,
              content: v.content,
              at: v.created_at.iso8601(3),
              sender: {
                id: v.sender.id,
                nickname: v.sender.nickname,
                icon_url: v.sender.icon_url,
                icon_thumb_url: v.sender.icon_url(:thumb)
              }
            }
          }
        }
    end
    context 'when over 50 has id' do
      let(:last_id) { direct_messages[10].id }
      let(:user) { FactoryBot.create(:user) }
      let!(:direct_messages) { (1..30).map{ [FactoryBot.create(:direct_message, sender: user, addressee: target), FactoryBot.create(:direct_message, sender: target, addressee: user)] }.flatten }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq direct_messages:
        direct_messages
          .take(10)
          .map {|v, i|
            {
              id: v.id,
              content: v.content,
              at: v.created_at.iso8601(3),
              sender: {
                id: v.sender.id,
                nickname: v.sender.nickname,
                icon_url: v.sender.icon_url,
                icon_thumb_url: v.sender.icon_url(:thumb)
              }
            }
          }
        }
    end
  end
end