module FollowMe
  module Event
    # The base event from which other events inherit.
    # Supports the attributes and functionality (comparisons) common to all
    # events.
    # Subclasses should overwrite #deliver to deliver themselves to clients.
    class Base
      include Comparable

      attr_reader :payload, :sequence_number

      def initialize(payload, sequence_number)
        @payload         = payload
        @sequence_number = sequence_number
      end

      def deliver(_user_connections, _user_relationships)
        fail 'Subclass responsibility'
      end

      def <=>(other_event)
        sequence_number <=> other_event.sequence_number
      end
    end
  end
end