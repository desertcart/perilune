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

module Perilune
  class Configuration
    def queue_name
      :dropbot_default
    end
  end
end

```

> Note - Perilune is using *default* as queue name.

You can configure the driver for Trifle::Stats :

```ruby
module Perilune
  class Configuration
    def stats_driver_config
      config = ::Trifle::Stats::Configuration.new
      config.driver =  ::Trifle::Stats::Driver::Postgres.new(
        ActiveRecord::Base.connection.instance_variable_get('@connection')
      )
      config.track_ranges = [:day]
      config.time_zone =  'Asia/Dubai'
      config
    end
  end
end
```
You can find more driver [here](https://trifle.io/docs/stats/drivers/)

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
