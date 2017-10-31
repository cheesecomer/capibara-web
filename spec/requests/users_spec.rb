require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users/new' do
    subject do
      get '/users/new'
      response
    end
    context 'When not signin' do
      it { expect(subject).to have_http_status :ok }
    end
    context 'When signin' do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      it { expect(subject).to have_http_status :found }
    end
  end

  describe 'POST /users' do
    subject do
      post '/users', params: { user: request_body }
      response
    end
    context 'When valie' do
      let(:request_body) { {} }
      it { expect(subject).to have_http_status :ok }
    end
    context 'When invalie' do
      let(:request_body) { { nickname: FFaker::Name.name, email: FFaker::Internet.email, password: 'password', password_confirmation: 'password' } }
      it { expect(subject).to have_http_status :found }
      it { expect { subject }.to change { User.all.count }.by(1) }
    end
    context 'When signin' do
      let(:user) { FactoryGirl.create(:user) }
      let(:request_body) { { nickname: FFaker::Name.name, email: FFaker::Internet.email, password: 'password', password_confirmation: 'password' } }
      before { sign_in user }
      it { expect(subject).to have_http_status :found }
      it { expect { subject }.to change { User.all.count }.by(0) }
    end
  end
end