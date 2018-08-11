module FollowMe
  # This class gets the event payloads and checks whether the event received
  # is the next in sequence. It then either delivers the event immediately or
  # stores it in the event store for later delivery.
  # It holds references to the connected users and user relationships to pass
  # them on to an event, so the event can deliver its payload appropriately.
  class EventDispatcher

    attr_reader :current_sequence_number

    def initialize(event_store, user_connections, relationships)
      @current_sequence_number = 1
      @event_store             = event_store
      @user_connections        = user_connections
      @relationships           = relationships
    end

    def process(event_payload)
      event = FollowMe::Event.create_from event_payload
      if next_in_sequence?(event)
        process_event(event)
      else
        @event_store.store event
      end
    rescue Event::UnknownEventError
      # ignore unknown events, would be nice to log for production
    end

    private
    def next_in_sequence?(event)
      event.sequence_number == @current_sequence_number
    end

    def process_event(event)
      deliver event
      while process_next_event?
        deliver @event_store.retrieve_next
      end
    end

    def process_next_event?
      (event = @event_store.next) && next_in_sequence?(event)
    end

    def deliver(event)
      event.deliver @user_connections, @relationships
      @current_sequence_number += 1
    end
  end
end