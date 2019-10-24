module GoPay
  class Gateway
    def initialize(config)
      @client = Client.new(config)
      @goid = config[:goid]
    end

    def create(payment_data)
      target = { target: { type: "ACCOUNT", goid: @goid } }
      @client.request :post, "/api/payments/payment", body_parameters: payment_data.merge(target)
    end

    def retrieve(id)
      @client.request :get, "/api/payments/payment/#{id}"
    end

    def refund(id, amount)
      @client.request :post, "/api/payments/payment/#{id}/refund", body_parameters: { amount: amount }
    end

    def void_recurrence(id)
      @client.request :post, "/api/payments/payment/#{id}/void-recurrence"
    end
  end
end