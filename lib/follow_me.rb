require 'forwardable'
require 'set'
require 'socket'
require 'gserver'

require_relative 'sorted'

require_relative 'follow_me/event/all'
require_relative 'follow_me/event'
require_relative 'follow_me/event_store'
require_relative 'follow_me/event_dispatcher'
require_relative 'follow_me/event_source_server'
require_relative 'follow_me/relationships'
require_relative 'follow_me/user_clients_server'
require_relative 'follow_me/user_connections'

# The FollowMe module acts as a top level name space but also offers short hand
# access to starting and stopping the servers and the necessary objects.
#
# Its motto is:
#                 "Follow me everything is alright"
#
module FollowMe
  class << self
    def start(opts = {})
      parse_options(opts)
      create_servers
      start_servers
      wait_for_servers
    rescue Interrupt
      stop
    end

    def stop
      puts 'Stopping the servers....' unless @silent
      @event_source_server.stop
      @user_clients_server.stop
      puts 'Stopped :)' unless @silent
    end

    private
    def parse_options(opts)
      @silent   = opts[:silent]
      @dontwait = opts[:dontwait]
    end

    def create_servers
      event_store        = FollowMe::EventStore.new
      user_connections   = FollowMe::UserConnections.new
      follower_relations = FollowMe::Relationships.new
      event_dispatcher   = FollowMe::EventDispatcher.new event_store,
                                                         user_connections,
                                                         follower_relations

      @user_clients_server = FollowMe::UserClientsServer.new user_connections
      @event_source_server = FollowMe::EventSourceServer.new event_dispatcher
    end

    def start_servers
      @event_source_server.start
      @user_clients_server.start
      puts 'Both servers started' unless @silent
    end

    def wait_for_servers
      unless @dontwait
        @event_source_server.join
        @user_clients_server.join
      end
    end
  end
end