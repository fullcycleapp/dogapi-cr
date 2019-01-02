require "../dogapi"

dog = Dogapi::V1::DashboardListService.new(ENV["DATADOG_KEY"], ENV["DATADOG_APP_KEY"])

dog.create("Test DashBoardList")

dog.update("12345","Test DashBoardList Updated")

dog.get("12345")

dog.all()

dog.delete("12345")

dog.get_items("12345")

dashboards = [
    {
        "type" => "integration_screenboard",
        "id" => 1414
    },
]
