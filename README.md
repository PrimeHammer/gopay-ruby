# gopay-ruby

[![Gem Version](https://badge.fury.io/rb/gopay-ruby.png)](http://badge.fury.io/rb/gopay-ruby)
[![Build Status](https://travis-ci.org/PrimeHammer/gopay-ruby.png?branch=master)](https://travis-ci.org/PrimeHammer/gopay-ruby)
[![Dependency Status](https://gemnasium.com/PrimeHammer/gopay-ruby.png)](https://gemnasium.com/PrimeHammer/gopay-ruby)
[![Code Climate](https://codeclimate.com/github/PrimeHammer/gopay-ruby.png)](https://codeclimate.com/github/PrimeHammer/gopay-ruby)
[![Coverage Status](https://coveralls.io/repos/PrimeHammer/gopay-ruby/badge.svg?branch=master&service=github)](https://coveralls.io/github/PrimeHammer/gopay-ruby?branch=master)

Unofficial wrapper for GoPay REST API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gopay-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gopay-ruby

## Usage

### Retrieve a payment

```ruby
GoPay::Payment.retrieve 35345534
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/PrimeHammer/gopay-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

