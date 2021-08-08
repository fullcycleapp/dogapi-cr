require "../dogapi"

dog = Dogapi::V1::TagService.new(ENV["DATADOG_KEY"], ENV["DATADOG_APP_KEY"])
dog.get_all
