module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user.access_token
    end

    def self.connected_users(&block)
      access_tokens =
        ActionCable \
          .server
          .open_connections_statistics
          .map(&:with_indifferent_access)
          .select { |v| select_subscriptions(v[:subscriptions], &block) }
          .map { |v| v[:identifier] }
          .uniq

      User.where access_token: access_tokens
    end

    protected

    def self.select_subscriptions(hash)
      hash \
        .map { |s| JSON.parse(s).with_indifferent_access }
        .select { |h| yield h }
        .present?
    end

    def find_verified_user
      find_verified_user_from_session
    rescue ActiveRecord::RecordNotFound
      begin
        find_verified_user_from_auth_header
      rescue UnauthorizationError
        reject_unauthorized_connection
      end
    end

    def find_verified_user_from_session
      User.find(session&.fetch('warden.user.user.key', nil)&.at(0)&.at(0))
    end

    def session
      key = Rails.application.config.session_options[:key]
      @session ||= cookies.encrypted[key]
    end

    def find_verified_user_from_auth_header
      auth_token = request.headers['Authorization']
      raise UnauthorizationError unless auth_token

      access_token = auth_token.split(' ').last
      user = User.where(access_token: access_token).first

      raise UnauthorizationError unless user

      user
    end
  end
end
