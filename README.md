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
Periline::Configuration do |config|
  config.queue_name = 'your_queue_name'
end
```

> Note - Perilune is using *default* as queue name.

You can configure the driver for Trifle::Stats :

```ruby
Periline::Configuration do |config|
  config.trifle_stat_driver = ::Trifle::Stats::Driver::Redis.new
  config.trifle_stat_track_ranges = %i[hour day week month quarter year]
  config.trifle_stat_time_zone = 'GMT'
  config.trifle_stat_beginning_of_week = :monday
end
```
You can find more driver [here](https://trifle.io/docs/stats/drivers/)

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
