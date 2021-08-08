require "../common"

module Dogapi
  class V1 # for namespacing

    class ScreenboardService < Dogapi::APIService
      def create_screenboard(description)
        request("POST", "/api/#{API_VERSION}/screen", nil, description, true)
      end

      def update_screenboard(board_id, description)
        request("PUT", "/api/#{API_VERSION}/screen/#{board_id}", nil, description, true)
      end

      def get_screenboard(board_id)
        request("GET", "/api/#{API_VERSION}/screen/#{board_id}", nil, nil, false)
      end

      def get_all_screenboards
        request("GET", "/api/#{API_VERSION}/screen", nil, nil, false)
      end

      def delete_screenboard(board_id)
        request("DELETE", "/api/#{API_VERSION}/screen/#{board_id}", nil, nil, false)
      end

      def share_screenboard(board_id)
        request("POST", "/api/#{API_VERSION}/screen/share/#{board_id}", nil, nil, false)
      end

      def revoke_screenboard(board_id)
        request("DELETE", "/api/#{API_VERSION}/screen/share/#{board_id}", nil, nil, false)
      end
    end
  end
end
