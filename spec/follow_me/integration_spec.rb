require 'spec_helper'

RSpec.describe 'Integration' do
  include AsyncHelper

  let(:event_source) {TCPSocket.new('127.0.0.1',event_port)}
  let(:event_port) {FollowMe::EventSourceServer::PORT}

  let(:client) {Helpers::TCP::ReadingClient.new client_id, user_port}
  let(:client_id) {'1'}
  let(:client2) {Helpers::TCP::ReadingClient.new client2_id, user_port}
  let(:client2_id) {'2'}
  let(:user_port) {FollowMe::UserClientsServer::PORT}

  before :each do
    FollowMe.start silent: true, dontwait: true
    client.start
    client2.start
    sleep 0.1 # give the clients time to connect
  end

  after :each do
    client.close
    client2.close
    FollowMe.stop
    sleep 0.1 # give them time to shut down
  end

  describe 'Follow Event' do
    let(:follow_payload) {"1|F|#{client2_id}|#{client_id}\n"}

    it 'relays the follow event' do
      event_source.write follow_payload
      eventually {expect(client.messages).to eq follow_payload}
    end
  end

  describe 'Broadcast Event' do
    let(:broadcast_payload) {"1|B\n"}

    it 'relays to all clients' do
      event_source.write broadcast_payload
      [client, client2].each do |test_client|
        eventually {expect(test_client.messages).to eq broadcast_payload}
      end
    end
  end

  describe 'a client closes the connection' do
    let(:to_disconnected_pattern) {"#id|P|1|2\n"}
    let(:other_client_message) {"1|P|6|1\n"}
    let(:broadcast_pattern) {"#id|B\n"}

    before :each do
      client2.close
      sleep 1
    end

    it 'does not crash trying to send a message to the disconnected client' do
      expect do
        send_payload_repeatedly event_source, to_disconnected_pattern
      end.not_to raise_error
    end

    it 'does not break, even with a broadcast' do
      send_payload_repeatedly event_source, broadcast_pattern
      expected_pattern = MAKING_SURE_TO_CRASH.times.inject('') do |pattern, i|
        pattern << broadcast_pattern.gsub('#id', (i + 1).to_s)
      end
      eventually{expect(client.messages).to eq expected_pattern}
    end

    it 'still works as expected relaying events to the other client' do
      event_source.write other_client_message
      eventually {expect(client.messages).to eq other_client_message}
    end

    MAKING_SURE_TO_CRASH = 4

    def send_payload_repeatedly(event_source_client, payload_pattern)
      # somehow the first couple of messages get through without raising
      # an error (client takes time to disconnect, probably)
      MAKING_SURE_TO_CRASH.times do |i|
        event_source_client.write payload_pattern.gsub('#id', (i + 1).to_s)
        sleep 0.1
      end
    end
  end

  describe 'multiple Events' do
    it 'handles them well and in the right order' do
      event_stream =  %w(1|F|2|1 2|S|1   3|P|1|2 4|B      5|U|2|1
                         6|S|1   7|F|1|2 8|B     9|P|3|12).shuffle.join("\n")
      event_source.write event_stream + "\n"
      client_1_events = %w(1|F|2|1 4|B 8|B).join("\n") + "\n"
      client_2_events = %w(2|S|1 3|P|1|2 4|B 7|F|1|2 8|B).join("\n") + "\n"
      eventually {expect(client.messages).to eq client_1_events}
      eventually {expect(client2.messages).to eq client_2_events}
    end
  end

  describe 'Unknown Event Type' do
    let(:unknown_event) {"2|A\n"}
    let(:known_event) {"1|B\n"}

    it 'does not crash and still handles events alright after receiving it' do
      event_source.write unknown_event
      event_source.write known_event
      eventually do
        expect(client.messages).to eq known_event
      end
    end
  end
end