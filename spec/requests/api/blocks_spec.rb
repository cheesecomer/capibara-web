require 'rails_helper'

RSpec.describe 'Blocks', type: :request do
  describe 'GET /api/blocks' do
    subject do
      get '/api/blocks', headers: request_header
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
      let(:other_user) { FactoryBot.create(:user) }
      let!(:other_blocks) { FactoryBot.create_list(:block, 10, owner: other_user) }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq blocks:[] }
    end
    context 'when not empty' do
      let(:user) { FactoryBot.create(:user) }
      let(:other_user) { FactoryBot.create(:user) }
      let!(:blocks) { FactoryBot.create_list(:block, 10, owner: user) }
      let!(:other_blocks) { FactoryBot.create_list(:block, 10, owner: other_user) }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq blocks: blocks.map {|v| { id: v[:id], target: { id: v.target.id, nickname: v.target.nickname } } } }
    end
  end

  describe 'POST /api/blocks' do
    subject do
      post '/api/blocks', params: request_json, headers: request_header
      response
    end
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json', 'X-ApplicationVersion': '1.0', 'X-Platform': 'test' }.merge optional_header
    end
    let(:target) { FactoryBot.create(:user) }
    context 'when unauthorized' do
      let(:optional_header) { {} }
      let(:error_response) { { message: I18n.t('devise.failure.unauthenticated') } }
      let(:request_json) { { target_id: target.id }.to_json }
      it { is_expected.to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq error_response }
    end
    context 'when authorized' do
      let(:user) { FactoryBot.create(:user) }
      let(:other_user) { FactoryBot.create(:user) }
      let(:request_json) { { target_id: target.id }.to_json }
      let!(:blocks) { FactoryBot.create_list(:block, 10, owner: user) }
      let!(:other_blocks) { FactoryBot.create_list(:block, 10, owner: other_user) }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :ok }
      it { expect { subject }.to change { Block.all.count }.by(1) }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq id: Block.last.id, target: { id: Block.last.target.id, nickname: Block.last.target.nickname } }
    end
  end

  describe 'DELETE /api/blocks' do
    subject do
      delete "/api/blocks/#{block.id}", headers: request_header
      response
    end
    let!(:block) { FactoryBot.create(:block, owner: owner) }
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let!(:blocks) { FactoryBot.create_list(:block, 10, owner: user) }
    let!(:other_blocks) { FactoryBot.create_list(:block, 10, owner: other_user) }
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json', 'X-ApplicationVersion': '1.0', 'X-Platform': 'test' }.merge optional_header
    end
    let(:error_response) { { message: I18n.t('devise.failure.unauthenticated') } }
    context 'when unauthorized' do
      let(:owner) { user }
      let(:optional_header) { {} }
      let(:request_json) { { target_id: target.id }.to_json }
      it { is_expected.to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq error_response }
    end
    context 'when myself' do
      let(:owner) { user }
      let(:request_json) { { target_id: target.id }.to_json }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :no_content }
      it { expect { subject }.to change { Block.all.count }.by(-1) }
    end
    context 'when others' do
      let(:owner) { other_user }
      let(:request_json) { { target_id: target.id }.to_json }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { is_expected.to have_http_status :forbidden }
    end
  end
end