module FollowMe
  module Event
    class StatusUpdate < Base
      attr_reader :from

      def initialize(payload, sequence_number, from)
        @from = from
        super(payload, sequence_number)
      end

      def deliver(user_connections, relationships)
        user_connections.send_message *relationships.followers(from), payload
      end
    end
  end
end