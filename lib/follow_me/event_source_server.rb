module FollowMe
  # The server the event source connects to, it forwards received payloads to
  # the event dispatcher.
  class EventSourceServer < GServer
    PORT = 9090

    attr_reader :event_dispatcher

    def initialize(event_dispatcher, port = PORT, *args)
      @event_dispatcher = event_dispatcher
      super port, *args
    end

    def serve(connection)
      loop do
        payload = connection.readline
        event_dispatcher.process payload
      end
    rescue EOFError
      connection.close
    end
  end
end