require_relative 'card_deck'

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

    puts "Player 1 starts with #{player1.cards.size} cards."
    puts "Player 2 starts with #{player2.cards.size} cards."
  end

  def play_round
    p1_card = player1.play
    p2_card = player2.play

    puts "Player 1 plays #{p1_card.rank} of #{p1_card.suit}"
    puts "Player 2 plays #{p2_card.rank} of #{p2_card.suit}"
    
    round_winner = compare_ranks(p1_card.rank, p2_card.rank)
    if round_winner == :tie
      tied_cards << p1_card
      tied_cards << p2_card
      puts "It's a tie! Cards go to tied pool."
    else
      round_winner.take(p1_card)
      round_winner.take(p2_card)
      tied_cards.each do |card|
        round_winner.take(card)
      end
      tied_cards.clear
      puts "#{round_winner.name} wins this round."
    end

    if player1.cards.size == 0
      @winner = player2
    elsif player2.cards.size == 0
      @winner = player1
    end
  end

  def compare_ranks(rank1, rank2)
    ranks = %w(2 3 4 5 6 7 8 9 10 J Q K A)
    rank1_index = ranks.index(rank1)
    rank2_index = ranks.index(rank2)

    if rank1_index > rank2_index
      return player1
    elsif rank2_index > rank1_index
      return player2
    else
      return :tie
    end
  end
end