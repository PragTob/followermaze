module FollowMe
  module Event
    class Unfollow < FromTo
      def deliver(user_connections, relationships)
        relationships.unfollow from, to
      end
    end
  end
end