# gopay-ruby

[![Gem Version](https://badge.fury.io/rb/gopay-ruby.png)](http://badge.fury.io/rb/gopay-ruby)
[![Build Status](https://travis-ci.org/PrimeHammer/gopay-ruby.png?branch=master)](https://travis-ci.com/PrimeHammer/gopay-ruby)
[![Code Climate](https://codeclimate.com/github/PrimeHammer/gopay-ruby.png)](https://codeclimate.com/github/PrimeHammer/gopay-ruby)
[![Coverage Status](https://coveralls.io/repos/github/PrimeHammer/gopay-ruby/badge.svg?branch=master)](https://coveralls.io/github/PrimeHammer/gopay-ruby?branch=master)

The GoPay Ruby allows Ruby applications to access to the GoPay REST API.

## Benefits
It does authorization under the hood automatically, supports multiple accounts. Easy configuration.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gopay-ruby', require: 'gopay'

```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gopay-ruby



## Usage

### Gateway

Before creating a payment, use Gateway object to configure your access to GoPay:

```ruby
gateway = GoPay::Gateway.new(gate: 'https://testgw.gopay.cz', goid: 123, client_id: 456, client_secret: 'xxx')
```

The values above are just examples. Note that you can use multiple Gateway objects to connect to different accounts. With one Gateway, you can do multiple requests.


### Create a Payment

Before charging a user, we need to create a new payment using our `gateway` object. The method will return a hash including a URL which you can use to popup payment modal or redirect the user to the GoPay payment page.

```ruby
gateway.create payment_data
```

#### payment_data example

```ruby
{
  "payer":{"allowed_payment_instruments": ["BANK_ACCOUNT"],
            "contact":{"first_name": "John",
                       "last_name": "Doe",
                       "email": "john.doe@example.com"
                      }
          },
  "target":{"type": "ACCOUNT",
            "goid": "8123456789"
           },
  "amount":"1000",
  "currency":"CZK",
  "order_number":"001",
  "order_description":"description001",
  "callback":{"return_url":"url.for.return",
              "notification_url":"url.for.notification"
             },
  "lang":"en"
}
```

#### Response example
This is a basic example of response hash, for more complex examples visit [GoPay API docs](https://doc.gopay.com).
```ruby
{
  "id":3000006529,
  "order_number":"001",
  "state":"CREATED",
  "amount":1000,"currency":"CZK",
  "payer":{"allowed_payment_instruments":["BANK_ACCOUNT"],
           "contact": {"first_name":"John",
                       "last_name":"Doe",
                       "email":"john.doe@example.com",
                      }
          },
  "target":{"type":"ACCOUNT",
            "goid":8123456789
           },
  "additional_params":[{"name":"invoicenumber",
                        "value":"2015001003"
                      }],
  "lang":"en",
  "gw_url":" https://gw.sandbox.gopay.com/gw/v3/bCcvmwTKK5hrJx2aGG8ZnFyBJhAvF"
}
```

### Retrieve the Payment
If you want to return a payment object from GoPay REST API.

```ruby
gateway.retrieve gopay_id
```

### Refund of the payment
This functionality allows you to refund payment paid by a customer.
You can use the refund in two ways. First option is a full refund payment and the other one is a partial refund. Both based on `amount` parameter.

```ruby
gateway.refund gopay_id, amount
```

### Cancellation of the recurring payment
The functionality allows you to cancel recurrence of a previously created recurring payment.

```ruby
gateway.void_recurrence gopay_id
```

## Dealing with errors
Errors are raised as GoPay::Error. The error contains error code error body returned by GoPay API.
You can easily catch errors in your models as shown below.

```ruby
begin
  response = gateway.refund(gopay_id, gopay_amount)
rescue GoPay::Error => exception
  log_gopay_error exception
end
```


## Testing

Use these env variables in `.env` file:

```
GOPAY_GATE='https://testgw.gopay.cz'

GOPAY_1_GOID=1111111111
GOPAY_1_CLIENT_ID=1
GOPAY_1_CLIENT_SECRET=x

GOPAY_2_GOID=2222222222
GOPAY_2_CLIENT_ID=2
GOPAY_2_CLIENT_SECRET=x
```

Then run:

```ruby
bundle exec rspec
```


### Upgrading 

#### 0.4.0

In short, using `GoPay` class and `GoPay::Payment` was deprecated.

Using `GoPay.configure` and `GoPay.request` is discouraged in favor of `Gateway` object. Instead of this:

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

please use `Gateway` object:

```ruby
gateway = GoPay::Gateway.new(gate: GATE_URL, goid: GOPAY_ID, client_id: GOPAY_CLIENT_ID, client_secret: GOPAY_SECRET)
```

`return_host` and `notification_host` will be deprecated as well.

Also `GoPay::Payment` will be deprecated. Instead of this:

```ruby
GoPay::Payment.retrieve gopay_id
```

use `Gateway` for creating payments, retrieval, refunds:

```ruby
gateway.retrieve gopay_id
```



## Full Documentation
Parameters for all GoPay methods follow the official documentation. For further explanation please visit [GoPay API docs](https://doc.gopay.com).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/PrimeHammer/gopay-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

