require 'unirest'
require 'gopay/error'

module GoPay
  class Payment
    def self.create(payer: nil, amount: nil, currency: nil, order_number: nil, order_description: nil, lang: nil, callback: nil, recurrence: nil)
      @allowed_methods = payer.allowed_methods
      @payer = payer
      @amount = amount
      @currency =currency
      @order_number = order_number
      @order_description = order_description
      @lang = lang
      @callback = callback
      @recurrence = recurrence
      GoPay.request :post, "/api/payments/payment", body_parameters: payment_data
    end

    def self.retrieve(id)
      GoPay.request :get, "/api/payments/payment/#{id}"
    end

    def self.void_recurrence(id)
      GoPay.request :post, "/api/payments/payment/#{id}/void-recurrence"
    end

    def self.refund(id, amount)
      GoPay.request :post, "/api/payments/payment/#{id}/refund", body_parameters: { amount: amount }
    end

    class << self
      private

      def payment_data
        if @recurrence
          payment_hash.merge(recurrence_hash)
        else
          payment_hash
        end
      end

      def payment_hash
        {
          "payer": {  "allowed_payment_instruments": @allowed_methods,
                      "contact":{"first_name": @payer.first_name,
                                 "last_name": @payer.last_name,
                                 "email": @payer.email
                                }
                    },
          "target": {
                      "type": "ACCOUNT",
                      "goid": GoPay.goid
                    },
          "amount": @amount,
          "currency": @currency,
          "order_number": @order_number,
          "order_description": @order_description,
          "callback":{
                      "return_url": @callback.return_url,
                      "notification_url": @callback.notification_url
                    },
          "lang": @lang
        }
      end

      def recurrence_hash
        {
          "recurrence":{"recurrence_cycle": @recurrence.cycle,
                        "recurrence_period": @recurrence.period,
                        "recurrence_date_to": @recurrence.date_to
                      }
        }
      end
    end
  end
end