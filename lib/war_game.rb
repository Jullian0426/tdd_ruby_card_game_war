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

  #TODO: Refactor for 7 line constraint
  def play_round
    p1_card = player1.play
    p2_card = player2.play

    puts "Player 1 plays #{p1_card.rank} of #{p1_card.suit}"
    puts "Player 2 plays #{p2_card.rank} of #{p2_card.suit}"
    
    comparison = p1_card.beat?(p2_card)
    if comparison == true
      round_winner = player1
    elsif comparison == false
      round_winner = player2
    else
      round_winner = :tie
    end

    if round_winner == :tie
      tied_cards << p1_card
      tied_cards << p2_card
      puts "It's a tie! Cards go to tied pool."
      play_round
    else
      round_winner.take([p1_card, p2_card])
      round_winner.take(tied_cards)
      tied_cards.clear
      puts "#{round_winner.name} wins this round."
    end

    if player1.cards.size == 0
      @winner = player2
    elsif player2.cards.size == 0
      @winner = player1
    end
  end
end