# frozen_string_literal: true

require_relative 'war_game'

game = WarGame.new
game.start
game.play_round until game.winner
puts "Winner: #{game.winner.name}"
