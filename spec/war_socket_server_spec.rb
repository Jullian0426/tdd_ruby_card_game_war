# frozen_string_literal: true

require 'spec_helper'
require 'socket'
require_relative '../lib/war_socket_server'
require_relative '../lib/client'

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
    expect { Client.new(@server.port_number) }.to raise_error(Errno::ECONNREFUSED)
  end

  it 'accepts new clients and starts a game if possible' do
    client1 = Client.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client
    client1.provide_input('Player 1')
    @server.new_player
    @server.create_game_if_possible
    expect(@server.games.count).to be 0
    client2 = Client.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client
    client2.provide_input('Player 2')
    @server.new_player
    @server.create_game_if_possible
    expect(@server.games.count).to be 1
  end

  it 'sends a message indicating a client is not in a game yet' do
    client1 = Client.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client
    client1.provide_input('Player 1')
    @server.new_player
    client1.capture_output
    @server.create_game_if_possible

    expect(client1.capture_output.chomp).to eq 'Waiting for more players...'
  end
end
