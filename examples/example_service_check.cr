require "../dogapi"

dog = Dogapi::V1::ServiceCheckService.new(ENV["DATADOG_KEY"], ENV["DATADOG_APP_KEY"])