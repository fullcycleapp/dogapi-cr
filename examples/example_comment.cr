require "../dogapi"

dog = Dogapi::V1::CommentService.new(ENV["DATADOG_KEY"], ENV["DATADOG_APP_KEY"])
dog.update_comment("Test Update Comment 2", "12345678901234567890")
