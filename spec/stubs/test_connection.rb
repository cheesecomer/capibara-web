class TestConnection
  attr_reader :identifiers, :logger, :access_token, :current_user, :server, :transmissions
  attr_accessor :group_identifier
  delegate :pubsub, to: :server

  def initialize(user, coder: ActiveSupport::JSON, subscription_adapter: SuccessAdapter)
    @coder = coder
    @identifiers = [ :access_token ]

    @current_user = user
    @access_token = user.access_token
    @logger = ActiveSupport::TaggedLogging.new ActiveSupport::Logger.new(StringIO.new)
    @server = TestServer.new(subscription_adapter: subscription_adapter)
    @transmissions = []
  end

  def transmit(cable_message)
    @transmissions << encode(cable_message)
  end

  def last_transmission
    decode @transmissions.last if @transmissions.any?
  end

  def decode(websocket_message)
    @coder.decode websocket_message
  end

  def encode(cable_message)
    @coder.encode cable_message
  end
end