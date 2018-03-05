require 'rails_helper'

RSpec.describe 'Blocks', type: :request do
  describe 'GET /api/blocks' do
    subject do
      get '/api/blocks', headers: request_header
      response
    end
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json' }.merge optional_header
    end
    context 'when unauthorized' do
      let(:error_response) { { message: I18n.t('devise.failure.unauthenticated') } }
      let(:optional_header) { {} }
      it { expect(subject).to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq error_response }
    end
    context 'when empty' do
      let(:user) { FactoryGirl.create(:user) }
      let(:other_user) { FactoryGirl.create(:user) }
      let!(:other_blocks) { FactoryGirl.create_list(:block, 10, owner: other_user) }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { expect(subject).to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq blocks:[] }
    end
    context 'when not empty' do
      let(:user) { FactoryGirl.create(:user) }
      let(:other_user) { FactoryGirl.create(:user) }
      let!(:blocks) { FactoryGirl.create_list(:block, 10, owner: user) }
      let!(:other_blocks) { FactoryGirl.create_list(:block, 10, owner: other_user) }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { expect(subject).to have_http_status :ok }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq blocks: blocks.map {|v| { id: v[:id], target: { id: v.target.id, nickname: v.target.nickname } } } }
    end
  end

  describe 'POST /api/blocks' do
    subject do
      post '/api/blocks', params: request_json, headers: request_header
      response
    end
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json' }.merge optional_header
    end
    let(:target) { FactoryGirl.create(:user) }
    context 'when unauthorized' do
      let(:optional_header) { {} }
      let(:error_response) { { message: I18n.t('devise.failure.unauthenticated') } }
      let(:request_json) { { target_id: target.id }.to_json }
      it { expect(subject).to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq error_response }
    end
    context 'when authorized' do
      let(:user) { FactoryGirl.create(:user) }
      let(:other_user) { FactoryGirl.create(:user) }
      let(:request_json) { { target_id: target.id }.to_json }
      let!(:blocks) { FactoryGirl.create_list(:block, 10, owner: user) }
      let!(:other_blocks) { FactoryGirl.create_list(:block, 10, owner: other_user) }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { expect(subject).to have_http_status :ok }
      it { expect { subject }.to change { Block.all.count }.by(1) }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq blocks: (blocks + [Block.last]).map {|v| { id: v[:id], target: { id: v.target.id, nickname: v.target.nickname } } } }
    end
  end

  describe 'DELETE /api/blocks' do
    subject do
      delete "/api/blocks/#{block.id}", headers: request_header
      response
    end
    let!(:block) { FactoryGirl.create(:block, owner: owner) }
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    let!(:blocks) { FactoryGirl.create_list(:block, 10, owner: user) }
    let!(:other_blocks) { FactoryGirl.create_list(:block, 10, owner: other_user) }
    let(:request_header) do
      { 'content-type': 'application/json', accept: 'application/json' }.merge optional_header
    end
    let(:error_response) { { message: I18n.t('devise.failure.unauthenticated') } }
    context 'when unauthorized' do
      let(:owner) { user }
      let(:optional_header) { {} }
      let(:request_json) { { target_id: target.id }.to_json }
      it { expect(subject).to have_http_status :unauthorized }
      it { expect(JSON.parse(subject.body, symbolize_names: true)).to eq error_response }
    end
    context 'when myself' do
      let(:owner) { user }
      let(:request_json) { { target_id: target.id }.to_json }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { expect(subject).to have_http_status :no_content }
      it { expect { subject }.to change { Block.all.count }.by(-1) }
    end
    context 'when others' do
      let(:owner) { other_user }
      let(:request_json) { { target_id: target.id }.to_json }
      let(:optional_header) { { authorization: "Token #{user.access_token}" } }
      it { expect(subject).to have_http_status :forbidden }
    end
  end
end