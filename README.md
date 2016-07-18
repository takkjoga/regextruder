# Regextruder

[![Build Status](https://travis-ci.org/takkjoga/regextruder.svg?branch=master)](https://travis-ci.org/takkjoga/regextruder)

Generate random characters by Regular Expression

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'regextruder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install regextruder

## Usage

```ruby
require 'regextruder'

r = Regextruder.generate(/[[:alnum:]]/)
r.result
# => "a"
r.number_of_ways
# => 62
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/takkjoga/regextruder. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

