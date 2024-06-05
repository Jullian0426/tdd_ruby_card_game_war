# frozen_string_literal: true

# Facilitates the connection between the clients and the game
class WarSocketRunner
  attr_accessor :game, :clients

  def initialize(game, clients)
    @game = game
    @clients = clients
    @ready_state = []
  end

  def run
    game.start
    until game.winner
      if players_ready?
        game.play_round
        reset_ready_state!
      else
        prompt_players
      end
    end
  end

  def prompt_players(round_data = nil)
    if round_data
      clients.each { |client| client.puts(round_data) }
    else
      clients.each { |client| client.puts('Type PLAY to play a card') }
    end
  end
end
