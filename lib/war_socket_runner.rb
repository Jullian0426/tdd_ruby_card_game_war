# frozen_string_literal: true

# Facilitates the connection between the clients and the game
class WarSocketRunner
  attr_accessor :game, :clients, :ready_state

  def initialize(game, clients)
    @game = game
    @clients = clients
    @ready_state = []
  end

  def run
    game.start
    run_loop until game.winner
  end

  def players_ready?
    (clients - ready_state).each do |client|
      input = capture_input(client)
      ready_state << client if input == 'PLAY'
    end
    ready_state.length == clients.length
  end

  def message_players(round_state = nil)
    if round_state
      clients.each { |client| client.puts(round_state) }
    else
      clients.each { |client| client.puts('Type PLAY to play a card') }
    end
  end

  def run_loop
    if players_ready?
      game.play_round
      message_players(game.round_state)
      ready_state.clear
    else
      message_players
    end
  end

  def capture_input(client)
    client.read_nonblock(1000).chomp
  rescue IO::WaitReadable
    ''
  end
end
