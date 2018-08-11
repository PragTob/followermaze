module FollowMe
  # The server accepting connections from user clients. The speciality here is
  # that there are many clients but all of them just send one message in the
  # beginning and then they just receive events.
  #
  # Note that using GServer here was too slow and unsuitable.
  class UserClientsServer
    PORT = 9099

    def initialize(connections, port = PORT)
      @user_connections = connections
      @server           = TCPServer.new port
      @server_thread    = nil
    end

    def start
      @server_thread = Thread.new do
        loop do
          begin
            connection = @server.accept
            payload = connection.readline
            @user_connections.new_connection payload.to_i, connection
          rescue EOFError
            connection.close
          end
        end
      end
    end

    def stop
      @server.shutdown
    rescue Errno::ENOTCONN
      # fix the jruby error/CRuby incompatibility, see jruby/jruby#2240
      @server.close
    end
  end

  def join
    @server_thread.join
  end
end