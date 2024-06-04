require_relative 'card_deck'
require_relative 'war_player'

class WarGame
  attr_accessor :player1, :player2, :deck, :winner, :tied_cards

  def initialize(player1, player2, deck = CardDeck.new)
    @player1 = player1
    @player2 = player2
    @deck = deck
    @winner = nil
    @tied_cards = []
  end

  def start
    deck.cards.shuffle!
    until deck.cards_left == 0 do
      player1.take(deck.deal)
      player2.take(deck.deal)
    end
  end

  def play_round
    p1_card, p2_card = player1.play, player2.play
    puts "Player 1 plays #{p1_card.rank} of #{p1_card.suit}\nPlayer 2 plays #{p2_card.rank} of #{p2_card.suit}"
    winning_player = round_winner(p1_card, p2_card)
    round_handler(winning_player, p1_card, p2_card)
    game_over?
  end

  def round_winner(p1_card, p2_card)
    result = p1_card.beat?(p2_card)
    result == true ? player1 : (result == false ? player2 : :tie)
  end

  def round_handler(winning_player, p1_card, p2_card)
    if winning_player == :tie
      tied_cards << p1_card << p2_card
      puts "It's a tie! Cards go to tied pool."
      play_round
    else
      winning_player.take([p1_card, p2_card] + tied_cards)
      tied_cards.clear
      puts "#{winning_player.name} wins this round."
    end
  end

  def game_over?
    if player1.cards.size == 0
      @winner = player2
    elsif player2.cards.size == 0
      @winner = player1
    end
  end
end