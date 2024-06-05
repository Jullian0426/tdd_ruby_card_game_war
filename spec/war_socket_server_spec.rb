# frozen_string_literal: true

require 'socket'
require_relative '../lib/war_socket_server'

class MockWarSocketClient
  attr_reader :socket, :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay = 0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ''
  end

  def close
    @socket&.close
  end
end

describe WarSocketServer do
  before(:each) do
    @clients = []
    @server = WarSocketServer.new
    @server.start
    sleep 0.1
  end

  after(:each) do
    @server.stop
    @clients.each(&:close)
  end

  it 'is not listening on a port before it is started' do
    @server.stop
    expect { MockWarSocketClient.new(@server.port_number) }.to raise_error(Errno::ECONNREFUSED)
  end

  it 'accepts new clients and starts a game if possible' do
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client('Player 1')
    @server.create_game_if_possible
    expect(@server.games.count).to be 0
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client('Player 2')
    @server.create_game_if_possible
    expect(@server.games.count).to be 1
  end

  it 'sends a message indicating a client is not in a game yet' do
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client('Player 1')
    @server.create_game_if_possible

    expect(client1.capture_output.chomp).to eq 'Waiting for more players'
  end
end
# TODO: Create helper method for creating clients
