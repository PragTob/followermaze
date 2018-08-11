module FollowMe
  # Saves all the active TCP connections to users and handles sending messages
  # to them.
  class UserConnections
    def initialize
      @connections = {}
    end

    def new_connection(id, connection)
      @connections[id] = connection
    end

    def connection(id)
      @connections[id]
    end

    def send_message(*ids, payload)
      ids.each do |id|
        begin
          connection(id).puts payload if @connections.has_key?(id)
        rescue SystemCallError, IOError => e
          @connections.delete(id)
        end
      end
    end

    def send_all(payload)
      send_message *@connections.keys, payload
    end
  end
end