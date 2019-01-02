require "../common"


module Dogapi
  class V1

    # Event-specific client affording more granular control than the simple Dogapi::Client
    class MetricService < Dogapi::APIService

      @buffer: String | Time | Nil

      def get(query, from, to)
        extra_params = {
          from:  from.to_i,
          to:    to.to_i,
          query: query,
        }
        request("GET", "/api/" + API_VERSION + "/query", extra_params, nil, false)
      end

      def upload(metrics)
        body = {
          :series => metrics
        }
        request("POST", "/api/" + API_VERSION + "/series", nil, body, true, false)
      end

      def submit_to_api(metric, points, scope, options = {} of String => String)
        payload = self.make_metric_payload(metric, points, scope, options)
        self.upload([payload])
      end

      def submit_to_buffer(metric, points, scope, options = {} of String => String)
        # payload = self.make_metric_payload(metric, points, scope, options)
        # @buffer << payload
        # return 200, {} of String => String
      end

      def flush_buffer()
        payload = @buffer
        @buffer = nil
        self.upload(payload)
      end

      def submit(*args)
        if !@buffer.nil?
          submit_to_buffer(*args)
        else
          submit_to_api(*args)
        end
      end

      def switch_to_batched()
        @buffer = Array.new
      end

      def switch_to_single()
        @buffer = Nil
      end

      def make_metric_payload(metric, points, scope, options)
        begin
          typ = options[:type]? || "gauge"

          if typ != "gauge" && typ != "counter"
            raise "metric type must be gauge or counter"
          end

          metric_payload = {
            :metric => metric,
            :points => points,
            :type => typ,
            :host => scope.host,
            :device => scope.device
          }

          # Add tags if there are any
          if options[:tags]?
            metric_payload[:tags] = options[:tags]?
          end

          return metric_payload
        rescue e
          suppress_error_if_silent e
        end
      end

    end
  end
end
