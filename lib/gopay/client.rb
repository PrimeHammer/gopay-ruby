require 'rest-client'

module GoPay
  class Client
    def initialize(config)
      @config = config
    end

    def request(method, path, body_parameters: {})
      token = token get_token_scope(method, path)
      content_type = get_content_type(path)

      body_parameters = content_type == 'application/json' ? body_parameters.to_json : from_hash_to_query(body_parameters)

      begin
        response = RestClient::Request.execute(method: method, url: @config[:gate]+path, payload: body_parameters, headers: { "Accept" => "application/json", "Content-Type" => content_type, "Authorization" => "Bearer #{token}" })
      rescue RestClient::ExceptionWithResponse => e
        raise Error.handle_gopay_error(e.response)
      end

      unless response.code == 200
        raise Error.handle_gopay_error(response)
      end

      JSON.parse response.body
    end

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
      response = RestClient.post(
        "#{@config[:gate]}/api/oauth2/token",
        { grant_type: 'client_credentials',
          scope: scope,
        },
        {
          "Accept" => "application/json",
          "Content-Type" => "application/x-www-form-urlencoded",
          "Authorization" => "Basic #{Base64.encode64(@config[:client_id] + ':' + @config[:client_secret])}"
        })
      JSON.parse(response.body)["access_token"]
    end

    def from_hash_to_query(hash)
      hash = hash == "{}" ? "{}" : URI.escape(hash.collect { |key,val| "#{CGI.escape(key.to_s)}=#{CGI.escape(val.to_s)}" }.join('&'))
      return hash
    end
  end
end