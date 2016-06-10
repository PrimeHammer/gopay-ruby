# gopay-ruby

[![Gem Version](https://badge.fury.io/rb/gopay-ruby.png)](http://badge.fury.io/rb/gopay-ruby)
[![Build Status](https://travis-ci.org/PrimeHammer/gopay-ruby.png?branch=master)](https://travis-ci.org/PrimeHammer/gopay-ruby)
[![Code Climate](https://codeclimate.com/github/PrimeHammer/gopay-ruby.png)](https://codeclimate.com/github/PrimeHammer/gopay-ruby)

The GoPay Ruby provides access to the GoPay REST API for Ruby language applications.

It automatically generate access tokens. Easy configuration through initializer.



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
Create an initializer:
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

### Establishment of payment
Before we can initiate gateway, we need to establish the payment. This will return gw_url, which you can initiate to inline or redirect payment gatewa

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

### Retrieve the payment
If you want to return payment object from GoPay REST API.

```ruby
GoPay::Payment.retrieve gopay_id
```

### Refund of the payment
The functionality which allows recovering funds for already made payment to the customer.
You can use refund in two ways. First is full refund payment and the other is partial refund. Both based on amount parameter.

```ruby
GoPay::Payment.refund gopay_id, amount
```

### Cancellation of the recurring payment
The functionality allows you to cancel recurrence of previously created recurring payment.

```ruby
GoPay::Payment.void_recurrence gopay_id
```
## Dealing with errors


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/PrimeHammer/gopay-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

