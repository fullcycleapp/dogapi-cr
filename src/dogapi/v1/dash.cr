require "../common"

module Dogapi
  class V1 # for namespacing

    class DashService < Dogapi::APIService
      def create_dashboard(title, description, graphs, template_variables = nil)
        body = {
          :title              => title,
          :description        => description,
          :graphs             => graphs,
          :template_variables => (template_variables or [] of ElementType),
        }
        request("POST", "/api/" + API_VERSION + "/dash", nil, body, true)
      end

      def update_dashboard(dash_id, title, description, graphs, template_variables = nil)
        body = {
          :title              => title,
          :description        => description,
          :graphs             => graphs,
          :template_variables => (template_variables or [] of ElementType),
        }
        request("PUT", "/api/" + API_VERSION + "/dash/#{dash_id}", nil, body, true)
      end

      def get_dashboard(dash_id)
        request("GET", "/api/" + API_VERSION + "/dash/#{dash_id}", nil, nil, false)
      end

      def get_dashboards
        request("GET", "/api/" + API_VERSION + "/dash/", nil, nil, false)
      end

      def delete_dashboard(dash_id)
        request("DELETE", "/api/" + API_VERSION + "/dash/#{dash_id}", nil, nil, false)
      end
    end
  end
end
