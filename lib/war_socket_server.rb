# frozen_string_literal: true

require 'socket'
require_relative 'war_game'
require_relative 'war_player'
require_relative 'war_socket_runner'

# The WarSocketServer class represents a socket server for the War card game.
class WarSocketServer
  attr_accessor :users, :games, :pending_clients

  def initialize
    @users = {}
    @games = []
    @pending_clients = {}
    @client_messages_sent = {}
    @accept_message = []
  end

  def port_number
    3336
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = 'Random Player')
    client = @server.accept_nonblock
    player = WarPlayer.new(player_name)
    pending_clients[client] = player
    users[client] = player
  rescue IO::WaitReadable, Errno::EINTR
    if @accept_message.empty?
      puts 'No client to accept'
      @accept_message << true
    end
  end

  def create_game_if_possible
    # TODO: change to MIN_PLAYERS variable
    if pending_clients.size >= 2
      games << WarGame.new(pending_clients.values)
      pending_clients.clear
      games.last
    elsif pending_clients.size == 1
      client = pending_clients.keys.first
      unless @client_messages_sent[client]
        client.puts('Waiting for more players')
        @client_messages_sent[client] = true
      end
      nil
    end
  end

  def run_game(game)
    runner(game).run
  end

  def runner(game)
    clients = game.players.map { |player| users.key(player) }
    WarSocketRunner.new(game, clients)
  end

  def stop
    @server&.close
  end
end
