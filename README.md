# lita-twitter

**lita-twitter** is an adapter for [Lita](https://github.com/jimmycuadra/lita) that allows you to use the robot with [Twitter](https://twitter.com/).

## Installation

Add this line to your lita's Gemfile:

    gem 'lita-twitter'


## Usage


```
# Gemfile of your Lita

source "https://rubygems.org"

gem 'lita', '~> 3.1.0'
gem "lita-twitter"
...
```

```ruby
# lita_config.rb

Lita.configure do |config|
  config.robot.name        = "your-bot-name"
  config.robot.log_level   = :info
  config.robot.adapter     = :twitter

  config.adapters.twitter.api_key             = "***"
  config.adapters.twitter.api_secret          = "***"
  config.adapters.twitter.access_token        = "***"
  config.adapters.twitter.access_token_secret = "***"
end
```


## Contributing

1. Fork it ( http://github.com/fukayatsu/lita-twitter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
