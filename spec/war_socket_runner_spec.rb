# frozen_string_literal: true

require 'spec_helper'
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

  let(:client1) { Client.new(@server.port_number, 'Player 1') }
  let(:client2) { Client.new(@server.port_number, 'Player 2') }

  before do
    @clients.push(client1)
    @server.accept_new_client(client1)
    client1.capture_output
    @clients.push(client2)
    @server.accept_new_client(client2)
    @game = @server.create_game_if_possible
  end

  it 'prompts all players to play a card' do
    runner = @server.runner(@game)
    runner.run_loop

    expect(client1.capture_output.chomp).to eq 'Type PLAY to play a card:'
    expect(client2.capture_output.chomp).to eq 'Type PLAY to play a card:'
  end

  it 'sends game data to the clients after a round is played' do
    card1 = PlayingCard.new('10', 'H')
    card2 = PlayingCard.new('8', 'D')
    @game.players[0].cards = [card1]
    @game.players[1].cards = [card2]
    @game.deck.cards.clear

    runner = @server.runner(@game)
    runner.run_loop

    client1.capture_output
    client2.capture_output
    client1.provide_input('PLAY')
    client2.provide_input('PLAY')

    runner.run_loop

    expect(client1.capture_output).to eq "Player 1 plays 10 of H\nPlayer 2 plays 8 of D\nPlayer 1 wins this round.\n"
    expect(client2.capture_output).to eq "Player 1 plays 10 of H\nPlayer 2 plays 8 of D\nPlayer 1 wins this round.\n"

    runner.run
    expect(client1.capture_output.chomp).to eq 'Player 1 wins the game!'
    expect(client2.capture_output.chomp).to eq 'Player 1 wins the game!'
  end
end
