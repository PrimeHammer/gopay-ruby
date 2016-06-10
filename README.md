# gopay-ruby

[![Gem Version](https://badge.fury.io/rb/gopay-ruby.png)](http://badge.fury.io/rb/gopay-ruby)
[![Build Status](https://travis-ci.org/PrimeHammer/gopay-ruby.png?branch=master)](https://travis-ci.org/PrimeHammer/gopay-ruby)
[![Code Climate](https://codeclimate.com/github/PrimeHammer/gopay-ruby.png)](https://codeclimate.com/github/PrimeHammer/gopay-ruby)

The GoPay Ruby allows Ruby applications to access to the GoPay REST API.

## Benefits
It does OAuth authorization under the hood automatically. Easy configuration through initializer.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gopay-ruby', require: 'gopay'

```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gopay-ruby

## Configure
The Gem is framework agnostic. However, if you use Rails, put the initializer in Rails config dir:
```ruby
config/initializers/gopay.rb
```

```ruby
GoPay.configure do |config|
  config.goid = GOPAY_ID
  config.client_id = GOPAY_CLIENT_ID
  config.client_secret = GOPAY_SECRET
  config.return_host = RETURN_HOST_URL
  config.notification_host = NOTIFICATION_HOST_URL
  config.gate = GATE_URL
end
```

## Usage

### Create a Payment
Before charging a user, we need to create a new payment. This will return a hash including a URL which you can use to popup payment or redirect the user to the GoPay payment page.

```ruby
GoPay::Payment.create payment_data
```

### payment_data example

```ruby
{
  "payer": {  "allowed_payment_instruments": ["BANK_ACCOUNT"],
              "contact":{"first_name": "",
                         "last_name": "",
                         "email": ""
                        }
            },
  "target": {
              "type": "ACCOUNT",
              "goid": "8123456789"
            },
  "amount": "1000",
  "currency": "CZK",
  "order_number": "001",
  "order_description": "description001",
  "callback":{
              "return_url": "url.for.return",
              "notification_url": "url.for.notification"
            },
  "lang": "en"
}
```

### Retrieve the Payment
If you want to return a payment object from GoPay REST API.

```ruby
GoPay::Payment.retrieve gopay_id
```

### Refund of the payment
This functionality allows you to refund payment paid by a customer.
You can use the refund in two ways. First option is a full refund payment and the other one is a partial refund. Both based on `amount` parameter.

```ruby
GoPay::Payment.refund gopay_id, amount
```

### Cancellation of the recurring payment
The functionality allows you to cancel recurrence of a previously created recurring payment.

```ruby
GoPay::Payment.void_recurrence gopay_id
```

## Dealing with errors
Errors are raised as GoPay::Error. The error contains error code error body returned by GoPay API.
You can easily catch errors in your models as shown below.

```ruby
begin
  response = GoPay::Payment.refund(gopay_id, gopay_amount)
rescue GoPay::Error => exception
  log_gopay_error exception
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/PrimeHammer/gopay-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

