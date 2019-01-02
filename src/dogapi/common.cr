require "http/client"
require "uri"
require "json"

module Dogapi

  class Scope
    @host : Int64 | String | Time | Nil
    @device : Int64 | String | Time | Nil

    property :host
    property :device
    
    def initialize(@host = nil, @device = nil)
      @host = host
      @device = device
    end
  end

  # Superclass that deals with the details of communicating with the DataDog API.
  class APIService

    @api_key : String
    @application_key : String | Nil
    @host : String | Nil
    @timeout :  Int32 | Nil
    @endpoint : String | Nil
    @api_host : String | Nil

    def initialize(@api_key, @application_key = nil, @silent = true, @timeout = nil, @endpoint = nil)
      @api_key = api_key
      @application_key = application_key
      @api_host = endpoint || Dogapi.find_datadog_host
      @timeout = timeout || 5
      @silent = silent
    end

    def suppress_error_if_silent(e)
      raise e unless @silent

      puts e
      return -1, {} of String => String
    end

    def request(method, url, extra_params, body, send_json, with_app_key=true)
      resp = nil
      uri = URI.parse(@api_host.to_s)
      tls = uri.scheme == "https" ? true : false

      client = HTTP::Client.new uri.host.to_s, uri.port, tls
      client.connect_timeout = @timeout.as(Number)

      # Before doing anything, set the app key in the request if true.
      app_key = nil
      if with_app_key == true
        app_key = @application_key
      end
      current_url = url + prepare_params(extra_params, app_key)
      
      client.before_request do |req|
        if send_json == true
          req.headers["Content-Type"] = "application/json"
          req.headers["User-Agent"] = "Crystal/Datadog Client"
          req.body = body.to_json
        end
      end
      resp = client.exec(method, current_url)
    end

    def prepare_params(extra_params, with_app_key)
      params = { 
          api_key: @api_key,
          application_key: @application_key ? with_app_key : nil
      }
      params = extra_params.merge params unless extra_params.nil?
      qs_params = params.map { |k, v| URI.escape(k.to_s) + '=' + URI.escape(v.to_s) }
      qs = '?' + qs_params.join('&')
      qs
    end

    def handle_response(resp)
      if resp.code == 204 || resp.body == "" || resp.body == "null" || resp.body.nil?
        return resp.code, {} of String => String
      end
      begin
        return resp.code, JSON.parse(resp.body)
      rescue
        is_json = resp.content_type == "application/json"
        raise "Response Content-Type is not application/json but is #{resp.content_type}: " + resp.body unless is_json
        raise "Invalid JSON Response: " + resp.body
      end
    end

  end
  
  def Dogapi.find_datadog_host
    # allow env-based overriding, useful for tests
    ENV["DATADOG_HOST"]? || "https://api.datadoghq.com"
  end

  @@hostname = ""

  def Dogapi.find_localhost
    begin
      # prefer hostname -f over Socket.gethostname
      @@hostname = %x[hostname -f].strip
    rescue
      raise "Cannot determine local hostname via hostname -f"
    end
  end
end
