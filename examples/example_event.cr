require "../dogapi"

dog = Dogapi::Client.new(ENV["DATADOG_KEY"])
dog.emit_event(Dogapi::Event.new("msg_text", {:msg_title => "Title"}))
