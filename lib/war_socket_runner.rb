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
      if ready_state.size == clients.size
        prompt_players(game.round_state)
        game.play_round
        ready_state.clear
      else
        prompt_players
        # TODO: remove hardcoding by updating ready_state
        game.winner = game.players[0]
      end
    end
  end

  def players_ready?
    input = ''
  end

  def prompt_players(round_state = nil)
    if round_state
      clients.each { |client| client.puts(round_state) }
    else
      clients.each { |client| client.puts('Type PLAY to play a card') }
    end
  end
end
