require "../common"

module Dogapi
  class V1 # for namespacing

    class TagService < Dogapi::APIService

      # Gets all tags in your org and the hosts tagged with them
      def get_all(source = nil)
        # extra_params = {} of String => String
        # if source
        #   extra_params["source"] = source
        # end
        request("GET", "/api/" + API_VERSION + "/tags/hosts", nil, {} of String => String, false)
      end

      # Gets all tags for a given host
      def get(host_id, source=nil, by_source=false)
        extra_params = {} of String => String
        if source
          extra_params["source"] = source
        end
        if by_source
          extra_params["by_source"] = "true"
        end

        request("GET", "/api/" + API_VERSION + "/tags/hosts/" + host_id.to_s, extra_params, nil, false)
      end

      # Adds a list of tags to a host
      def add(host_id, tags, source=nil)
        extra_params = {} of String => String
        if source
          extra_params["source"] = source
        end

        body = {
          :tags => tags
        }

        request("POST", "/api/" + API_VERSION + "/tags/hosts/" + host_id.to_s, extra_params, body, true)
      end

      # Remove all tags from a host and replace them with a new list
      def update(host_id, tags, source=nil)
        extra_params = {} of String => String
        if source
          extra_params["source"] = source
        end

        body = {
          :tags => tags
        }

        request("PUT", "/api/" + API_VERSION + "/tags/hosts/" + host_id.to_s, extra_params, body, true)
      end

      # <b>DEPRECATED:</b> Spelling mistake temporarily preserved as an alias.
      def detatch(host_id)
        # warn "[DEPRECATION] Dogapi::V1::TagService.detatch() is deprecated. Use `detach` instead."
        detach(host_id)
      end

      # Remove all tags from a host
      def detach(host_id, source=nil)
        extra_params = {} of String => String
        if source
          extra_params["source"] = source
        end

        request("DELETE", "/api/" + API_VERSION + "/tags/hosts/" + host_id.to_s, extra_params, nil, false)
      end

    end

  end
end