require "../common"

module Dogapi
  class V1
    class CommentService < Dogapi::APIService
      # Submit a comment.
      def comment(message, options = {} of String => String)
        body = {
            :message => message
        }.merge(options)
        request("POST", "/api/" + API_VERSION + "/comments", nil, body, true, true)
      end

      # Update a comment.
      def update_comment(comment_id, message, options = {} of String => String)
          body = {
            :message => message
        }.merge(options)
        request("PUT", "/api/" +  API_VERSION + "/comments/#{comment_id}", nil, body, true, true)
      end

      def delete_comment(comment_id)
        request("DELETE", "/api/" +  API_VERSION + "/comments/#{comment_id}", nil, nil, false, true)
      end
    end
  end
end