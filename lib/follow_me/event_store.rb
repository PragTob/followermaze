module FollowMe
  # Stores events in a data structure, that allows to retrieve them in an order
  # so that the requirements of events arriving in order can be met.
  class EventStore
    extend Forwardable

    def_delegators :@sorted_queue, :empty?

    def initialize
      @sorted_queue = Sorted::Queue.new
    end

    def store(event)
      @sorted_queue.insert event
    end

    def next
      @sorted_queue.peek
    end

    def retrieve_next
      @sorted_queue.poll
    end
  end
end