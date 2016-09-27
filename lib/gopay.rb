require 'gopay/payment'

module GoPay
  class << self
    attr_accessor :return_host, :notification_host, :gate, :client_id, :goid, :client_secret
  end

  def self.configure
    yield self
  end

  def self.request(method, path, body_parameters: {})
    token = token get_token_scope(method, path)
    content_type = get_content_type(path)

    body_parameters = content_type == 'application/json' ? body_parameters.to_json : from_hash_to_query(body_parameters)

    response = Unirest.send(method, GoPay.gate+path, headers: { "Accept" => "application/json", "Content-Type" => content_type, "Authorization" => "Bearer #{token}" }, parameters: body_parameters)

    unless response.code == 200
      raise GoPay::Error.handle_gopay_error(response)
    end

    response.body
  end

  class << self
    private

    def get_token_scope(method, path)
      if method == :post && path == '/api/payments/payment'
        'payment-create'
      else
        'payment-all'
      end
    end

    def get_content_type(path)
      if (path == '/api/payments/payment') || (path =~ /create-recurrence/)
        'application/json'
      else
        'application/x-www-form-urlencoded'
      end
    end

    # payment-create - for new payment
    # payment-all - for testing state etc
    def token(scope = 'payment-create')
      response = Unirest.post(
        "#{gate}/api/oauth2/token",
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/x-www-form-urlencoded",
          "Authorization" => "Basic #{Base64.encode64(client_id + ':' + client_secret)}"
        },
        parameters: "grant_type=client_credentials&scope=#{scope}")
      response.body["access_token"]
    end

    def from_hash_to_query(hash)
      hash = hash == "{}" ? "{}" : URI.escape(hash.collect { |key,val| "#{CGI.escape(key.to_s)}=#{CGI.escape(val.to_s)}" }.join('&'))
      return hash
    end
  end
end