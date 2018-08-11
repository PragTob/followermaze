module FollowMe
  module Event
    class Broadcast < Base
      def deliver(user_connections, _)
        user_connections.send_all payload
      end
    end
  end
end