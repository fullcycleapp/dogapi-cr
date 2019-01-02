require "../common"


module Dogapi

    # Metadata class for storing the details of an event
    class Event
        @msg_text : String
        @msg_title : Array(String) | Int64 | String | Nil
        @date_happened : Array(String) | Int64 | String | Nil
        @priority : Array(String) | Int64 | String | Nil
        @parent : Array(String) | Int64 | String | Nil
        @tags: Array(String) | Int64 | String | Nil
        @aggregation_key: Array(String) | Int64 | String | Nil
        @alert_type: Array(String) | Int64 | String | Nil
        @event_type: Array(String) | Int64 | String | Nil
        @source_type_name: Array(String) | Int64 | String | Nil

        @object_map: Hash(Symbol, Array(String) | Int64 | String | Nil)
        
        property :date_happened,
        :msg_title,
        :msg_text,
        :priority,
        :parent,
        :tags,
        :aggregation_key

    # Optional arguments:
    #  :date_happened => time in seconds since the epoch (defaults to now)
    #  :msg_title     => String
    #  :priority      => String
    #  :parent        => event ID (integer)
    #  :tags          => array of Strings
    #  :event_object  => String
    #  :alert_type    => 'success', 'error'
    #  :event_type    => String
    #  :source_type_name => String
    #  :aggregation_key => String
    def initialize(msg_text, options = {} of String => String)
            defaults = {
                :date_happened => Time.now.to_unix,
                :msg_title => "",
                :priority => "normal",
                :parent => nil,
                :tags => [] of String,
                :aggregation_key => nil
            }
            options = defaults.merge(options)

            @msg_text = msg_text
            @date_happened = options[:date_happened]
            @msg_title = options[:msg_title]
            @priority = options[:priority]
            @parent = options[:parent]
            @tags = options[:tags]
            @aggregation_key = options[:event_object]? || options[:aggregation_key]?
            @alert_type = options[:alert_type]?
            @event_type = options[:event_type]?
            @source_type_name = options[:source_type_name]?

            @object_map = options
        end

        def to_hash
            @object_map
        end
    end

    class V1
        class EventService < Dogapi::APIService

        MAX_BODY_LENGTH = 4000
        MAX_TITLE_LENGTH = 100

        # <b>DEPRECATED:</b> Going forward, use the V1 services. This legacy service will be
        # removed in an upcoming release.
        def submit(api_key, event, scope=nil, source_type = {} of String => String)
                scope = scope || Dogapi::Scope.new()

                params = {
                    :api_key => api_key,
                    :api_version => API_VERSION,
            
                    :host => scope.host,
                    :device => scope.device,
            
                    :metric => event.metric,
                    :date_detected => event.date_detected,
                    :date_happened => event.date_happened,
                    :alert_type => event.alert_type,
                    :event_type => event.event_type,
                    :event_object => event.event_object,
                    :msg_title => event.msg_title[0..MAX_TITLE_LENGTH - 1],
                    :msg_text => event.msg_text[0..MAX_BODY_LENGTH - 1],
                    :json_payload => event.json_payload,
                }
        
                # if source_type
                #     params[:source_type] = source_type
                # end
        
                request("POST", "/api/" +  API_VERSION + "/event/submit", params)
        end
        
        # <b>DEPRECATED:</b> Going forward, use the V1 services. This legacy service will be
        # removed in an upcoming release.
        def start(api_key, event, scope, source_type = {} of String => String)
                response = submit api_key, event, scope, source_type
                success = nil

                begin
                    yield response
                rescue
                    success = false
                    raise
                else
                    success = true
                ensure
                    return finish api_key, response["id"], success
                end
        end
        

        def post(event, scope=nil)
            scope = scope || Dogapi::Scope.new()
            body = event.to_hash.merge({
                :title => event.msg_title,
                :text => event.msg_text,
                :date_happened => event.date_happened.to_s.to_i,
                :host => scope.host,
                :device => scope.device,
                :aggregation_key => event.aggregation_key.to_s
            })
            request("POST", "/api/" + API_VERSION + "/events", nil, body, true)
        end

          # Get the details of an event
          #
          # +id+ of the event to get
          def get_event(id)
            @event_svc.get(id)
          end
      
          # Delete an event
          #
          # +id+ of the event to delete
          def delete_event(id)
            @event_svc.delete(id)
          end

          
           private def finish(api_key, event_id, successful = {} of String => String)
                params = {
                api_key: api_key,
                event_id: event_id
                }
                request("POST", "/api/" + API_VERSION + "/event/ended", params)
            end
        end
    end
end