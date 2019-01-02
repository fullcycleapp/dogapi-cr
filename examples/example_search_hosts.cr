require "../dogapi"

dog = Dogapi::V1::HostsService.new(ENV["DATADOG_KEY"], ENV["DATADOG_APP_KEY"])
dog.search_hosts()