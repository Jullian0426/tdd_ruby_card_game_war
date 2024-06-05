require 'socket'
require_relative '../lib/war_socket_server'

class MockWarSocketClient
  attr_reader :socket
  attr_reader :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ""
  end

  def close
    @socket.close if @socket
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
    @clients.each do |client|
      client.close
    end
  end

  it "is not listening on a port before it is started"  do
    @server.stop
    expect {MockWarSocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end

  it "accepts new clients and starts a game if possible" do
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client("Player 1")
    @server.create_game_if_possible
    expect(@server.games.count).to be 0
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player 2")
    @server.create_game_if_possible
    expect(@server.games.count).to be 1
  end

  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...

  it "sends a message indicating a client is not in a game yet" do
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client("Player 1")
    @server.create_game_if_possible

    expect(client1.capture_output.chomp).to eq "Waiting for more players"
  end

  describe "#run_game" do
    let(:client1) { MockWarSocketClient.new(@server.port_number) }
    let(:client2) { MockWarSocketClient.new(@server.port_number) }
    before do
      @clients.push(client1)
      @server.accept_new_client("Player 1")
      @server.create_game_if_possible
      client1.capture_output
      @clients.push(client2)
      @server.accept_new_client("Player 2")
      @game = @server.create_game_if_possible
      @server.run_game(@game)
    end
    
    it "prompts all players to play a card" do
      expect(client1.capture_output.chomp).to eq "Type PLAY to play a card"
      expect(client2.capture_output.chomp).to eq "Type PLAY to play a card"
    end
    
    it "sends waiting for other players message after player1 plays a card" do
      client1.capture_output
      client1.provide_input("PLAY")
      expect(client1.capture_output.chomp).to eq "Waiting for input from other players"
    end
  end
end