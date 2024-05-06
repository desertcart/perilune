# Perilune
Perilune is a wrapper around your import/export files so you can process them on the background and don't have to worry about the orchestration around them. Perilune does not worry what mime-type of a file you are working with. It only handles orchestration around it.

It uses ActiveJob for processing and includes a WebView with some analytics. All you need is to write your own Task files that process the import or export. Perilune will take care of the rest.

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

Perilune is a Ruby on Rails Engine that you need to mount into your Rails Application. You may want to change default values in a custom initializer.

Configuration lets you modify two attributes. `queue_name` and `stats_driver`. 
- `queue_name` - Perilune uses ActiveJob to process its tasks. It defaults to `default` queue and you may want to change it to dedicated queue.
- `stats_driver` - Perilune uses `Trifle::Stats` to track its analytics. It defaults to `Redis` driver and you may want to change it to driver of your choice.

``` ruby
# config/initializers/perilune.rb

# frozen_string_literal: true

Perilune.configure do |config|
  config.queue_name = 'test'
  config.stat_driver = Trifle::Stats::Driver::Postgres.new(
    ActiveRecord::Base.connection.instance_variable_get('@connection')
  )
end
```
You can find more driver [here](https://trifle.io/docs/stats/drivers/)

``` ruby
# config/routes.rb

namespace :admin do
  # ...
  mount Perilune::Engine, at: '/perilune'
  # ...
end
```

## Usage

Once you have perilune configured and mounted, you need to integrate it into your app. Remember, Perilune only helps you process files.

First run a following migration:

``` ruby
create_table :perilune_tasks do |t|
  t.string :task_type
  t.string :task_klass
  t.jsonb :attrs
  t.string :state
  t.text :tags, array: true, default: []
  t.jsonb :error_data
  t.datetime :processing_at
  t.datetime :processed_at
  t.datetime :failed_at
  t.timestamps
end
add_index :perilune_tasks, :tags, using: :gin
```

Then go ahead and build your views with form and controller that handles its submit. No magic here, just regular rails file input. Inside of your controller that handles form submission use `Perilune::Tasks::Imports::CreateOperation` to create a task with attached file.

``` ruby
def import
  import_operation.perform
  if import_operation.success?
    redirect_to root_path, notice: "Yay, good for you!"
  else
    redirect_to root_path, alert: "Oh no!"
  end
end

def import_operation
  @import_operation ||= Perilune::Tasks::Imports::CreateOperation.new(
    domain: :main,
    file: import_params[:file].tempfile,
    task_klass: 'MyImportTask',
    tags: [current_user.id],
    attrs: {}
  )
end
```

And then write your Task class.

``` ruby
require 'csv'

class MyImportTask
  include Perilune::Tasks::Mixin
  
  def operate
    parse_csv
  end
  
  def parse_csv
    CSV.parse(file, headers: true) do |row|
      process_row(row: row)
    end
  end
  
  def process_row(row:)
    # Do whatever you need with your row.
  end
end
```

Thats pretty much it.

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
