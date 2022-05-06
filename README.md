# Perilune
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "perilune"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install perilune
```

## Configuration
You can use diffrent queue name for cron job:

```ruby
# frozen_string_literal: true

Perilune.configure do |config|
  config.queue_name = 'test'
end

```

> Note - Perilune is using *default* as queue name.

You can configure the driver for Trifle::Stats :

```ruby
Perilune.configure do |config|
  config.stat_driver = Trifle::Stats::Driver::Postgres.new(
    ActiveRecord::Base.connection.instance_variable_get('@connection')
  )
end
```
You can find more driver [here](https://trifle.io/docs/stats/drivers/)

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
