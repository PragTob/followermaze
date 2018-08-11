require 'spec_helper'

RSpec.describe FollowMe::UserClientsServer do
  include AsyncHelper

  subject(:server) {described_class.new connections}

  let(:connections) {double 'connections', new_connection: true}
  let(:port) {FollowMe::UserClientsServer::PORT}

  before :each do
    server.start
  end

  after :each do
    server.stop
  end

  it 'handles a simple user connection' do
    Helpers::TCP.send_payload port, "2932\n"
    eventually do
      expect(connections).to have_received(:new_connection).with(2932, anything)
    end
  end

  it 'handles multiple connections' do
    user_ids = [2932, 874, 675]
    user_ids.each {|id| Helpers::TCP.send_payload port, "#{id}\n"}
    eventually do
      expect(connections).to have_received(:new_connection).exactly(3).times
    end
  end

  it 'handles connections fine even if a client disconnects immediately' do
    socket = TCPSocket.new 'localhost', port
    socket.close
    sleep 0.1
    Helpers::TCP.send_payload port, "333\n"
    eventually do
      expect(connections).to have_received(:new_connection).with(333, anything)
    end
  end
end