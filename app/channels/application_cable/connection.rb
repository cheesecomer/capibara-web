module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    def self.connected_user(&block)
      ActionCable.server
        .open_connections_statistics
        .map{|v| v.with_indifferent_access }
        .select {|v| v[:subscriptions].map{|s| JSON.parse(s).with_indifferent_access }.select{|h| yield h }.present? }
        .map{|v| v[:identifier]}
        .uniq
        .size
    end

    protected

    def find_verified_user
      find_verified_user_from_session rescue find_verified_user_from_auth_header
    rescue
      reject_unauthorized_connection
    end

    def find_verified_user_from_session
      User.find(session['warden.user.user.key'][0][0])
    end

    def session
      @session ||= cookies.encrypted[Rails.application.config.session_options[:key]]
    end

    def find_verified_user_from_auth_header
      auth_token = request.headers['Authorization']
      raise UnauthorizationError unless auth_token
      raise UnauthorizationError unless auth_token.include?(':')

      user_id = auth_token.split(':').first
      user = User.find(user_id)

      raise UnauthorizationError unless Devise.secure_compare(user.access_token, auth_token)

      user
    end
  end
end
