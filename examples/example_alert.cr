require "../dogapi"

dog = Dogapi::Client.new(ENV["DATADOG_KEY"])
dog.emit_point("test.api.test_metric", 4.0)
