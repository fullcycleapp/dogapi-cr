require "../dogapi"

dog = Dogapi::V1::MonitorService.new(ENV["DATADOG_KEY"], ENV["DATADOG_APP_KEY"])
dog.get_all_downtimes
