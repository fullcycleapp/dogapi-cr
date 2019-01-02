require "../common"

module Dogapi
  class V1

    class ServiceCheckService < Dogapi::APIService

      def service_check(check, host, status, options = {} of String => String)
        body = {
          :check => check,
          :host_name => host,
          :status => status
        }.merge options

        request("POST", "/api/#{API_VERSION}/check_run", nil, body, true)
      end

    end

  end
end