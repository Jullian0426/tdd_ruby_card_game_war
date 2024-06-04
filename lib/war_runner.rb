require_relative 'war_game'
require_relative 'war_player'

player1 = WarPlayer.new("Player 1")
player2 = WarPlayer.new("Player 2")

game = WarGame.new(player1, player2)
game.start

until game.winner do
  game.play_round
end
puts "Winner: #{game.winner.name}"
