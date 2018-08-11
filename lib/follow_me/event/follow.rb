module FollowMe
  module Event
    class Follow < FromTo
      def deliver(user_connections, user_relationships)
        user_relationships.follow from, to
        user_connections.send_message to, payload
      end
    end
  end
end