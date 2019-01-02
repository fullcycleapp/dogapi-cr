require "../common"

module Dogapi
  class V1 # for namespacing

    class UserService < Dogapi::APIService

      # <b>DEPRECATED:</b> Going forward, we're using a new and more restful API,
      # the new methods are get_user, create_user, update_user, disable_user
      def invite(emails, options= {} of String => String)
        warn "[DEPRECATION] Dogapi::V1::UserService::invite has been deprecated "\
             "in favor of Dogapi::V1::UserService::create_user"
        body = {
          emails => emails,
        }.merge options

        request("POST", "/api/#{API_VERSION}/invite_users", nil, body, true)
      end

      # Create a user
      #
      # :description => Hash: user description containing 'handle' and 'name' properties
      def create_user(description= {} of String => String)
        request("POST", "/api/#{API_VERSION}/user", nil, description, true)
      end

      # Retrieve user information
      #
      # :handle => String: user handle
      def get_user(handle)
        request("GET", "/api/#{API_VERSION}/user/#{handle}", nil, nil, false)
      end

      # Retrieve all users
      def get_all_users
        request("GET", "/api/#{API_VERSION}/user", nil, nil, false)
      end

      # Update a user
      #
      # :handle => String: user handle
      # :description => Hash: user description optionally containing 'name', 'email',
      # 'is_admin', 'disabled' properties
      def update_user(handle, description= {} of String => String)
        request("PUT", "/api/#{API_VERSION}/user/#{handle}", nil, description, true)
      end

      # Disable a user
      #
      # :handle => String: user handle
      def disable_user(handle)
        request("DELETE", "/api/#{API_VERSION}/user/#{handle}", nil, nil, false)
      end

    end

  end
end