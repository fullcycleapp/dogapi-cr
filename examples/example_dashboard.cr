require "../dogapi"

dog = Dogapi::V1::DashService.new(ENV["DATADOG_KEY"], ENV["DATADOG_APP_KEY"])
dog.get_dashboards()
