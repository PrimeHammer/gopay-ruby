require 'spec_helper'

GoPay.configure do |config|
  config.gate = ENV['GOPAY_GATE']
  config.goid = ENV['GOPAY_1_GOID']
  config.client_id = ENV['GOPAY_1_CLIENT_ID']
  config.client_secret =  ENV['GOPAY_1_CLIENT_SECRET']
end

describe GoPay::Payment, vcr: VCR_OPTIONS do
  subject { described_class }

  describe 'retrieve' do
    it 'returns existing payment' do
      expect(subject.retrieve 3090060402).to include("id" => 3090060402)
    end

    it 'returns gopay error when payment not found' do
      expect { subject.retrieve 100 }.to raise_error(GoPay::Error)
    end
  end

  describe 'void_recurrence' do
    # the payment has to be paid. Use gw_url to go to gateway and pay
    it 'returns existing payment' do
      expect(subject.void_recurrence 3090067123).to include("id" => 3090067123)
    end

    it 'returns gopay error when payment not found' do
      expect { subject.void_recurrence 100 }.to raise_error(GoPay::Error)
    end
  end

  describe 'refund' do
    # the payment has to be paid. Use gw_url to go to gateway and pay
    it 'returns existing payment' do
      expect(subject.refund 3090067162, 10000).to include("id" => 3090067162, "result" => "FINISHED")
    end

    it 'returns gopay error when payment not found' do
      expect { subject.refund 100, 100 }.to raise_error(GoPay::Error)
    end
  end

  describe 'create' do
    let(:params) { { payer: { allowed_payment_instruments: ["PAYMENT_CARD"],
                              contact: { first_name: 'John',
                                          last_name: 'Doe',
                                          email: 'john@example.com' } },
                     amount: 10000,
                     currency: 'CZK',
                     order_number: 'order-1',
                     order_description: 'foo',
                     lang: 'CS',
                     callback: { return_url: 'http://localhost',
                                              notification_url: 'http://localhost/2' } } }
    let(:recurrence_params) { { recurrence: { recurrence_cycle: 'WEEK', recurrence_period: 10, recurrence_date_to: '2050-01-01' } } }

    it 'returns existing payment for standard payment' do
      expect(GoPay::Payment.create(params)).to include(
        "order_number" => "order-1",
        "state" => "CREATED",
        "amount" => 10000,
        "currency" => "CZK",
        "payer" => include(
          "allowed_payment_instruments" => ["PAYMENT_CARD"],
          "contact" => include(
            "first_name" => "John",
            "last_name" => "Doe",
            "email" => "john@example.com"
          )
        ),
        "lang" => "cs"
      )
    end

    it 'returns existing payment for recurrent payment' do
      expect(GoPay::Payment.create(params.merge(recurrence_params))).to include(
        "order_number" => "order-1",
        "state" => "CREATED",
        "amount" => 10000,
        "currency" => "CZK",
        "payer" => include(
          "allowed_payment_instruments" => ["PAYMENT_CARD"],
          "contact" => include(
            "first_name" => "John",
            "last_name" => "Doe",
            "email" => "john@example.com"
          )
        ),
        "recurrence" => {
          "recurrence_cycle" => "WEEK",
          "recurrence_period" => 10,
          "recurrence_date_to" => "2050-01-01",
          "recurrence_state" => "REQUESTED"
        },
        "lang" => "cs"
      )
    end
  end
end