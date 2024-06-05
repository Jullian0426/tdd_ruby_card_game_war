require 'socket'
require_relative 'war_game'
require_relative 'war_player'

class WarSocketServer
  attr_accessor :users, :games, :pending_clients

  def initialize
    @users = {}
    @games = []
    @pending_clients = {}
  end

  def port_number
    3336
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    player = WarPlayer.new(player_name)
    pending_clients[client] = player
    users[client] = player
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible
    if users.size >= 2
      game = WarGame.new(*pending_clients.values)
      games << game
      pending_clients.clear
      games.last
    else
      pending_clients.keys.first.puts("Waiting for more players")
    end
  end

  def run_game(game)
    player1, player2 = game.player1, game.player2
    client1, client2 = users.key(player1), users.key(player2)
  end

  def stop
    @server.close if @server
  end
end