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
    until game.winner
      prompt_players
      sleep(0.1) until players_ready?
      game.play_round
      prompt_players(game.round_state)
      ready_state.clear
    end
  end

  def players_ready?
    clients.each do |client|
      input = client.capture_output.chomp
      ready_state << client if input == 'PLAY'
    end
    ready_state.length == clients.length
  end

  def prompt_players(round_state = nil)
    if round_state
      clients.each { |client| client.puts(round_state) }
    else
      clients.each { |client| client.puts('Type PLAY to play a card') }
    end
  end
end
