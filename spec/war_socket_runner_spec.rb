# frozen_string_literal: true

require_relative '../lib/war_socket_runner'
require_relative 'war_socket_server_spec'

describe WarSocketRunner do
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

  let(:client1) { MockWarSocketClient.new(@server.port_number) }
  let(:client2) { MockWarSocketClient.new(@server.port_number) }

  before do
    @clients.push(client1)
    @server.accept_new_client('Player 1')
    client1.capture_output
    @clients.push(client2)
    @server.accept_new_client('Player 2')
    client2.capture_output
    @game = @server.create_game_if_possible
    @server.run_game(@game)
  end

  it 'prompts all players to play a card' do
    expect(client1.capture_output.chomp).to eq 'Type PLAY to play a card'
    expect(client2.capture_output.chomp).to eq 'Type PLAY to play a card'
  end

  xit 'sends game data to the clients after a round is played' do
    client1.capture_output
    client2.capture_output
    client1.provide_input('PLAY')
    client2.provide_input('PLAY')

    expect(client1.capture_output).to include()
    expect(client2.capture_output).to include()
  end
end
