require "../common"

module Dogapi
  class V1 # for namespacing

    class AlertService < Dogapi::APIService

      def alert(query, options = {} of String => String)
        body = {
          "query": query,
        }.merge options
        request("POST", "/api/" +  API_VERSION + "/alert", options, body)
      end

      def update_alert(alert_id, query, options)
        body = {
          "query": query,
        }.merge options

        request("PUT", "/api/" +  API_VERSION + "/alert/#{alert_id}", body)
      end

      def get_alert(alert_id)
        request("GET", "/api/" +  API_VERSION + "/alert/#{alert_id}", nil)
      end

      def delete_alert(alert_id)
        request("DELETE", "/api/" +  API_VERSION + "/alert/#{alert_id}", nil)
      end

      def get_all_alerts
        request("GET", "/api/" +  API_VERSION + "/alert", nil)
      end

      def mute_alerts
        request("POST", "/api/", +  API_VERSION + "/mute_alerts", nil)
      end

      def unmute_alerts
        request("POST", "/api/", +  API_VERSION + "/unmute_alerts", nil)
      end

    end

  end
end