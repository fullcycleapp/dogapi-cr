require "../common"

module Dogapi
  class V1 # for namespacing

    class MonitorService < Dogapi::APIService
      def monitor(type, query, options = {} of String => String)
        body = {
          :type  => type,
          :query => query,
        }.merge(options)

        request("POST", "/api/#{API_VERSION}/monitor", nil, body, true)
      end

      def update_monitor(monitor_id, query, options)
        body = {
          :query => query,
        }.merge(options)

        request("PUT", "/api/#{API_VERSION}/monitor/#{monitor_id}", nil, body, true)
      end

      def get_monitor(monitor_id, options = {} of String => String)
        extra_params = options.clone
        # :group_states is an optional list of statuses to filter returned
        # groups. If no value is given then no group states will be returned.
        # Possible values are: "all", "ok", "warn", "alert", "no data".

        if extra_params[:group_states].respond_to?(:join)
          extra_params[:group_states] = extra_params[:group_states].join(',')
        end

        request("GET", "/api/#{API_VERSION}/monitor/#{monitor_id}", extra_params, nil, false)
      end

      def delete_monitor(monitor_id)
        request("DELETE", "/api/#{API_VERSION}/monitor/#{monitor_id}", nil, nil, false)
      end

      def get_all_monitors(options = {} of String => String)
        extra_params = options.clone
        # :group_states is an optional list of statuses to filter returned
        # groups. If no value is given then no group states will be returned.
        # Possible values are: "all", "ok", "warn", "alert", "no data".
        if extra_params[:group_states].respond_to?(:join)
          extra_params[:group_states] = extra_params[:group_states].join(',')
        end

        # :tags is an optional list of scope tags to filter the list of monitors
        # returned. If no value is given, then all monitors, regardless of
        # scope, will be returned.
        extra_params[:tags] = extra_params[:tags].join(',') if extra_params[:tags].respond_to?(:join)

        request("GET", "/api/#{API_VERSION}/monitor", extra_params, nil, false)
      end

      def validate_monitor(type, query, options = {} of String => String)
        body = {
          :type  => type,
          :query => query,
        }.merge options

        request("POST", "/api/#{API_VERSION}/monitor/validate", nil, body, true)
      end

      def mute_monitors
        request("POST", "/api/#{API_VERSION}/monitor/mute_all", nil, nil, false)
      end

      def unmute_monitors
        request("POST", "/api/#{API_VERSION}/monitor/unmute_all", nil, nil, false)
      end

      def mute_monitor(monitor_id, options = {} of String => String)
        request("POST", "/api/#{API_VERSION}/monitor/#{monitor_id}/mute", nil, options, true)
      end

      def unmute_monitor(monitor_id, options = {} of String => String)
        request("POST", "/api/#{API_VERSION}/monitor/#{monitor_id}/unmute", nil, options, true)
      end

      def search_monitors(options = {} of String => String)
        request("GET", "/api/#{API_VERSION}/monitor/search", options, nil, false)
      end

      def search_monitor_groups(options = {} of String => String)
        request("GET", "/api/#{API_VERSION}/monitor/groups/search", options, nil, false)
      end

      #
      # DOWNTIMES

      def schedule_downtime(scope, options = {} of String => String)
        body = {
          :scope => scope,
        }.merge options

        request("POST", "/api/#{API_VERSION}/downtime", nil, body, true)
      end

      def update_downtime(downtime_id, options = {} of String => String)
        request(Net::HTTP::Put, "/api/#{API_VERSION}/downtime/#{downtime_id}", nil, options, true)
      end

      def get_downtime(downtime_id)
        request("GET", "/api/#{API_VERSION}/downtime/#{downtime_id}", nil, nil, false)
      end

      def cancel_downtime(downtime_id)
        request("DELETE", "/api/#{API_VERSION}/downtime/#{downtime_id}", nil, nil, false)
      end

      def cancel_downtime_by_scope(scope)
        request("POST", "/api/#{API_VERSION}/downtime/cancel/by_scope", nil, {:scope => scope}, false)
      end

      def get_all_downtimes
        request("GET", "/api/#{API_VERSION}/downtime", nil, nil, true)
      end

      #
      # HOST MUTING

      def mute_host(hostname, options = {} of String => String)
        request("POST", "/api/#{API_VERSION}/host/#{hostname}/mute", nil, options, true)
      end

      def unmute_host(hostname)
        request("POST", "/api/#{API_VERSION}/host/#{hostname}/unmute", nil, nil, true)
      end
    end
  end
end
