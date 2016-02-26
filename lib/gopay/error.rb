module GoPay
  class Error < StandardError

    def self.handle_gopay_error(response)
      new("#{response.code} : #{response.body}")
    end
  end
end