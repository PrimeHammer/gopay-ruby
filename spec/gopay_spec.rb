require 'spec_helper'

describe GoPay::Payment, vcr: VCR_OPTIONS do
  subject { described_class }

  describe 'retrieve' do
    it 'returns existing payment' do
      expect(subject.retrieve 3026370321).to include("id" => 3026370321)
    end

    it 'returns gopay error when payment not found' do
      expect { subject.retrieve 100 }.to raise_error(GoPay::Error)
    end
  end

  # find a new payment after you delete casette
  describe 'void_recurrence' do
    it 'returns existing payment' do
      expect(subject.void_recurrence 3027321817).to include("id" => 3027321817)
    end

    it 'returns gopay error when payment not found' do
      expect { subject.void_recurrence 100 }.to raise_error(GoPay::Error)
    end
  end

  # find a new payment after you delete casette
  describe 'refund' do
    it 'returns existing payment' do
      expect(subject.refund 3027334050, 46900).to include("id" => 3027334050)
    end

    it 'returns gopay error when payment not found' do
      expect { subject.refund 100, 100 }.to raise_error(GoPay::Error)
    end
  end

  describe 'create' do
    let(:params) { { payer: OpenStruct.new(allowed_methods: ["BANK_ACCOUNT"],
                                           first_name: 'John',
                                           last_name: 'Doe',
                                           email: 'john@example.com'),
                     amount: 10000,
                     currency: 'CZK',
                     order_number: 'order-1',
                     order_description: 'foo',
                     lang: 'CS',
                     callback: OpenStruct.new(return_url: 'http://localhost',
                                              notification_url: 'http://localhost/2') } }
    let(:recurrence_params) { { recurrence: OpenStruct.new(cycle: 'WEEK', period: 10, date_to: '2018-01-01') } }

    it 'returns existing payment for standard payment' do
      expect(GoPay::Payment.create(params)).to include(
        "order_number" => "order-1",
        "state" => "CREATED",
        "amount" => 10000,
        "currency" => "CZK",
        "payer" => include(
          "allowed_payment_instruments" => ["BANK_ACCOUNT"],
          "contact" => include(
            "first_name" => "John",
            "last_name" => "Doe",
            "email" => "john@example.com"
          )
        ),
        "recurrence" => nil,
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
          "allowed_payment_instruments" => ["BANK_ACCOUNT"],
          "contact" => include(
            "first_name" => "John",
            "last_name" => "Doe",
            "email" => "john@example.com"
          )
        ),
        "recurrence" => {
          "recurrence_cycle" => "WEEK",
          "recurrence_period" => 10,
          "recurrence_date_to" => "2018-01-01",
          "recurrence_state" => "REQUESTED"
        },
        "lang" => "cs"
      )
    end
  end
end