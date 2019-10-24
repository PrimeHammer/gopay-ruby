require 'gopay/client'
require 'gopay/payment'
require 'gopay/gateway'
require 'gopay/error'

module GoPay
  class << self
    attr_accessor :return_host, :notification_host, :gate, :client_id, :goid, :client_secret
  end

  def self.configure
    yield self
  end

  def self.request(method, path, body_parameters: {})
    client = GoPay::Client.new({gate: gate, client_id: client_id, goid: goid, client_secret: client_secret})
    client.request(method, path, body_parameters: body_parameters)
  end
end