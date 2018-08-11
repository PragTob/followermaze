require 'spec_helper'

RSpec.describe FollowMe::UserConnections do
  subject(:user_connections) {described_class.new}

  let(:connection) {double 'connection', puts: true}
  let(:connection2) {double 'connection2', puts: true}
  let(:connection_id) {44}
  let(:connection2_id) {77}


  before :each do
    user_connections.new_connection connection_id, connection
  end

  it 'stores connections by id' do
    expect(user_connections.connection(connection_id)).to eq connection
  end

  describe '#send_message' do
    it 'sends a message to the associated connection' do
      user_connections.send_message(connection_id, 'payload')
      expect(connection).to have_received(:puts).with 'payload'
    end

    it 'can send messages to multiple connections' do
      user_connections.new_connection connection2_id, connection2
      user_connections.send_message connection_id, connection2_id, 'payload'
      expect_connections_received [connection, connection2], 'payload'
    end

    it 'does not attempt to send messages to not existing connections' do
      expect do
        user_connections.send_message 1337, 'payload'
      end.not_to raise_error
    end

    describe 'broken client' do
      it 'removes broken connections' do
        allow(connection).to receive(:puts) {raise Errno::EPIPE}
        user_connections.send_message connection_id, 'dontcare'
        expect(subject.connection(connection_id)).to be_nil
      end
    end
  end

  describe '#send_all' do
    before :each do
      user_connections.new_connection connection2_id, connection2
    end

    it 'sends the payload to all connections' do
      user_connections.send_all 'payload'
      expect_connections_received [connection, connection2], 'payload'
    end

    it 'handles disconnected clients' do
      allow(connection).to receive(:puts) {raise Errno::EPIPE}
      user_connections.send_all 'broadcast!'
      expect(subject.connection(connection_id)).to be_nil
    end
  end

  def expect_connections_received(connections, payload)
    connections.each do |conn|
      expect(conn).to have_received(:puts).with payload
    end
  end
end