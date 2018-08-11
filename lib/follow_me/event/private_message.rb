module FollowMe
  module Event
    class PrivateMessage < FromTo
      def deliver(user_connections, _)
        user_connections.send_message(to, payload)
      end
    end
  end
end