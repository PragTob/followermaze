require 'spec_helper'

RSpec.describe FollowMe::EventSourceServer do
  include AsyncHelper

  subject(:event_server) {described_class.new event_dispatcher}

  let(:event_dispatcher) {double 'event dispatcher', process: true}
  let(:port) {FollowMe::EventSourceServer::PORT}

  before :each do
    event_server.start
  end

  after :each do
    event_server.stop
    until event_server.stopped?
      sleep 0.1
    end
  end

  it 'forwards input o the event dispatcher' do
    payload = '1|F|7|33'
    Helpers::TCP.send_payload port, payload
    eventually do
      expect(event_dispatcher).to have_received(:process).with payload
    end
  end

  it 'still works well after a client disconnected' do
    multiple_previous_connections
    payload = '4|B\n'
    Helpers::TCP.send_payload port, payload
    eventually do
      expect(event_dispatcher).to have_received(:process).with payload
    end
  end

  def multiple_previous_connections
    # this worked best to provoke the failure I was looking for
    Helpers::TCP.send_payload port, 'something'
    sleep 0.5
    Helpers::TCP.send_payload port, 'payload'
    sleep 0.5
  end
end