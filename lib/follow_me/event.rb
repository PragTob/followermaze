module FollowMe
  # The basic event module serves as a namespace and as a factory to create the
  # events in this namespace based on a given event payload.
  module Event

    TYPE_TO_EVENT = {'F' => Follow,
                     'U' => Unfollow,
                     'B' => Broadcast,
                     'P' => PrivateMessage,
                     'S' => StatusUpdate
                    }
    SEPARATOR     = '|'

    class UnknownEventError < StandardError; end

    class << self
      def create_from(event_payload)
        sequence_number, type, from, to = event_payload.chomp.split(SEPARATOR)
        event_class = TYPE_TO_EVENT[type]
        if event_class
          arguments   = [sequence_number, from, to].reject(&:nil?).map(&:to_i)
          event_class.new event_payload, *arguments
        else
          raise UnknownEventError
        end
      end
    end
  end
end