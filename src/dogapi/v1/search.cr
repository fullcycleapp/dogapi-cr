require "../common"

module Dogapi
  class V1 # for namespacing

    class SearchService < Dogapi::APIService

      def search(query)
        # Deprecating search for hosts
        split_query = query.split(':')
        if split_query.length > 1 && split_query[0] == "hosts"
        end
        extra_params = {
          :q => query
        }
        request("GET", "/api/#{API_VERSION}/search", extra_params, nil, false)
      end

    end

  end
end