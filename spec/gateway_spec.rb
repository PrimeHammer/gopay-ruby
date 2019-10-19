require 'spec_helper'

describe GoPay::Gateway, vcr: VCR_OPTIONS do
  let(:gopay_config) {
    {
      gate: ENV['GOPAY_GATE'],
      goid: ENV['GOPAY_1_GOID'],
      client_id: ENV['GOPAY_1_CLIENT_ID'],
      client_secret: ENV['GOPAY_1_CLIENT_SECRET']
    }
  }

  before(:each) {
    @gateway = GoPay::Gateway.new(gopay_config)
  }

  it 'allows to switch goid' do
    gateway1 = GoPay::Gateway.new(gopay_config)
    expect(gateway1.retrieve 3090060402).to include("id" => 3090060402, "target" => include("goid" => ENV['GOPAY_1_GOID'].to_i))
    gateway2 = GoPay::Gateway.new(
      gate: ENV['GOPAY_GATE'],
      goid: ENV['GOPAY_2_GOID'],
      client_id: ENV['GOPAY_2_CLIENT_ID'],
      client_secret: ENV['GOPAY_2_CLIENT_SECRET']
    )
    expect(gateway2.retrieve 3088999875).to include("id" => 3088999875, "target" => include("goid" => ENV['GOPAY_2_GOID'].to_i))
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
      expect(@gateway.create(params)).to include(
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
      expect(@gateway.create(params.merge(recurrence_params))).to include(
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

  describe 'retrieve' do
    it 'returns existing payment' do
      expect(@gateway.retrieve 3090060402).to include("id" => 3090060402)
    end

    it 'returns gopay error when payment not found' do
      expect { @gateway.retrieve 100 }.to raise_error(GoPay::Error)
    end
  end

  describe 'refund' do
    # the payment has to be paid. Use gw_url to go to gateway and pay
    it 'returns existing payment' do
      expect(@gateway.refund 3090066980, 10000).to include("id" => 3090066980, "result" => "FINISHED")
    end

    it 'returns gopay error when payment not found' do
      expect { @gateway.refund 100, 100 }.to raise_error(GoPay::Error)
    end
  end

  describe 'void_recurrence' do
    # the payment has to be paid. Use gw_url to go to gateway and pay
    it 'returns existing payment' do
      expect(@gateway.void_recurrence 3090066941).to include("id" => 3090066941)
    end

    it 'returns gopay error when payment not found' do
      expect { @gateway.void_recurrence 100 }.to raise_error(GoPay::Error)
    end
  end
end