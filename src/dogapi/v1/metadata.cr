require "../common"

module Dogapi
  class V1
    class MetadataService < Dogapi::APIService
      def get(metric_name)
        request("GET", "/api/#{API_VERSION}/metrics/#{metric_name}", nil, nil, false)
      end

      def update(metric_name, options = {} of String => String)
        request("PUT", "/api/#{API_VERSION}/metrics/#{metric_name}", nil, options, true)
      end
    end
  end
end
