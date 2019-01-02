require "../dogapi"

dog = Dogapi::V1::UserService.new(ENV["DATADOG_KEY"], ENV["DATADOG_APP_KEY"])
dog.get_all_users()