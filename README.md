# dogapi-cr

dogapi-cr is a crystal client for [DataDog](https://www.datadoghq.com)'s [API](https://docs.datadoghq.com/api/) the code is based loosely on Datadog's [Ruby Library](https://github.com/DataDog/dogapi-rb).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  dogapi:
    github: fullcycleapp/dogapi
```

## Usage
When running the code below you need the `DATADOG_KEY` and a `DATADOG_APP_KEY` set, go to [Integrations > APIs](https://app.datadoghq.com/account/settings#api) in datadog to get your API and app key.

```crystal
require "dogapi"

dog = Dogapi::Client.new(ENV["DATADOG_KEY"])
dog.emit_point("test.api.test_metric", 4.0)
```

Take a look at the `examples/` folder for more examples.

## Contributing

1. Fork it (<https://github.com/fullcycleapp/dogapi-cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- Calvin Hill ([@return](https://github.com/return)) - creator, maintainer
- Wesley Hill ([@hako](https://github.com/hako)) - maintainer


## LICENSE

Apache 2.0