require "time"
require "./v1"

require "./v1/alert"
require "./v1/comment"
require "./v1/dash"
require "./v1/dashboard_list"
require "./v1/embed"
require "./v1/event"
require "./v1/hosts"
require "./v1/metadata"
require "./v1/metric"
require "./v1/monitor"
require "./v1/screenboard"
require "./v1/search"
require "./v1/service_check"
require "./v1/snapshot"
require "./v1/tag"
require "./v1/user"

module Dogapi
  class Client
    @api_key : String
    @application_key : String | Nil
    @host : String | Nil
    @device : String | Nil
    @timeout : String | Nil
    @endpoint : String | Nil
    @datadog_host : String | Nil
    @host : String | Time | Nil

    property :datadog_host

    def initialize(@api_key, @application_key = nil, @host = nil, @device = nil, @silent = true, @timeout = nil, @endpoint = nil)
      @datadog_host = endpoint || Dogapi.find_datadog_host
      @host = host || Dogapi.find_localhost
      @device = device

      @metric_svc = Dogapi::V1::MetricService.new(@api_key, @application_key, silent, timeout, @datadog_host)
      @event_svc = Dogapi::V1::EventService.new(@api_key, @application_key, silent, timeout, @datadog_host)
      @comment_svc = Dogapi::V1::CommentService.new(@api_key, @application_key, silent, timeout, @datadog_host)
      @alert_svc = Dogapi::V1::AlertService.new(@api_key, @application_key, silent, timeout, @datadog_host)
    end

    def comment(message, options = {} of String => String)
      scope = override_scope options
      @comment_svc.comment(message, options)
    end

    #
    # METRICS

    # Record a single point of metric data
    #
    # Optional arguments:
    #  :timestamp => Ruby stdlib Time`
    #  :host      => String
    #  :device    => String
    #  :options   => Map
    #
    # options[:type] = "counter" to specify a counter metric
    # options[:tags] = ["tag1", "tag2"] to tag the point
    def emit_point(metric, value, options = {} of String => String)
      defaults = {:timestamp => Time.local.to_unix}
      options = defaults.merge(options)

      self.emit_points(
        metric,
        [[options[:timestamp], value]],
        options
      )
    end

    # Record a set of points of metric data
    #
    # +points+ is an array of <tt>[Time, value]</tt> doubles
    #
    # Optional arguments:
    #  :host   => String
    #  :device => String
    #  :options   => Map
    #
    # options[:type] = "counter" to specify a counter metric
    # options[:tags] = ["tag1", "tag2"] to tag the point
    def emit_points(metric, points, options = {} of String => String)
      scope = override_scope options

      points.each do |p|
        # if p[0].is_a?(Time) ==
        #   raise Exception.new("")
        # end
        # p[0] = p[0].to_i
        p[1] = p[1].to_f # TODO: stupid to_f will never raise an exception
      end

      @metric_svc.submit(metric, points, scope, options)
    end

    def get_points(query, from, to)
      @metric_svc.get(query, from, to)
    end

    def emit_event(event, options = {} of String => String)
      scope = override_scope options

      @event_svc.post(event, scope)
    end

    def batch_metrics
      @metric_svc.switch_to_batched
      begin
        yield
        @metric_svc.flush_buffer # flush_buffer should returns the response from last API call
      ensure
        @metric_svc.switch_to_single
      end
    end

    private def override_scope(options = {} of String => String)
      defaults = {:host => @host, :device => @device}
      options = defaults.merge(options)
      Scope.new(options[:host], options[:device])
    end
  end
end
