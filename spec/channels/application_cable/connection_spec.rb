require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  let(:user) { FactoryGirl.create :user }
  let(:connection) { started_connection }
  let(:unstarted_connection) { setup_connection }

  let(:env) do
    Rack::MockRequest.env_for(
      '/',
      {
        'HTTP_CONNECTION' => 'upgrade',
        'HTTP_UPGRADE' => 'websocket',
        'HTTP_HOST' => 'localhost',
        'HTTP_ORIGIN' => 'http://localhost'
      }.merge(optional_heder)
    )
  end

  let(:setup_connection) do
    ApplicationCable::Connection.new(TestServer.new(subscription_adapter: SuccessAdapter), env)
  end

  let(:started_connection) do
    connection = setup_connection
    connection.process
    connection.send(:handle_open)
    connection
  end

  describe '.conect' do
    context 'when find user from session' do
      before(:each) { allow(User).to receive(:find) { user }}
      let (:optional_heder) { {} }
      it  { expect(connection.current_user).to eq(user) }
      it  { expect(connection.access_token).to eq(user.access_token) }
    end

    context 'when valid authorization heder' do
      before(:each) do
        allow(User).to receive(:find) { raise ActiveRecord::RecordNotFound }
      end
      let (:optional_heder) { { 'HTTP_AUTHORIZATION' => "Token #{user.access_token}" } }
      it  { expect(connection.current_user).to eq(user) }
      it  { expect(connection.access_token).to eq(user.access_token) }
    end

    context 'when invalid authorization heder' do
      before(:each) do
        allow(User).to receive(:find) { raise ActiveRecord::RecordNotFound }
      end
      let (:optional_heder) { { 'HTTP_AUTHORIZATION' => "Token #{Digest::SHA256.hexdigest SecureRandom.uuid}" } }
      it 'should reject' do
        allow(unstarted_connection).to receive(:transmit) { |**params|
          expect(params[:type]).to eq(ActionCable::INTERNAL[:message_types][:rejection])
        }
        started_connection
      end
    end

    context 'when not found user' do
      let (:optional_heder) { {} }
      it 'should reject' do
        allow(unstarted_connection).to receive(:transmit) { |**params|
          expect(params[:type]).to eq(ActionCable::INTERNAL[:message_types][:rejection])
        }
        unstarted_connection.process
        unstarted_connection.send(:handle_open)
      end
    end
  end
end
