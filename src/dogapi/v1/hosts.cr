require "../common"

module Dogapi
  class V1 # for namespacing

    # Hosts API
    class HostsService < Dogapi::APIService
      def search_hosts(options = {} of String => String)
        request("GET", "/api/#{API_VERSION}/hosts", nil, options, true)
      end

      def totals
        request("GET", "/api/#{API_VERSION}/hosts/totals", nil, nil, true)
      end
    end
  end
end
