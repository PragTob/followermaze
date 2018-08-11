module Helpers
  module TCP

    class << self
      def send_payload(port, payload)
        socket = TCPSocket.new('127.0.0.1', port)
        socket.write payload
        socket.close
      end
    end

    class ReadingClient

      attr_reader :messages

      def initialize(id, port)
        @socket = TCPSocket.new('127.0.0.1', port)
        @id = id
        @messages = ''
      end

      def start
        Thread.new do
          begin
            @socket.puts @id
            loop do
              new_message = @socket.readline
              @messages << new_message
            end
          rescue EOFError
            close
          end
        end
      end

      def close
        @socket.close unless @socket.closed?
      end
    end

  end
end