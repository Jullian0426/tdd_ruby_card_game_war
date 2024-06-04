require_relative 'playing_card'

class CardDeck
  attr_accessor :cards

  RANKS = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  SUITS = %w(H D C S)
  
  def initialize(cards = make_cards)
    @cards = cards
  end
  
  def make_cards
    SUITS.flat_map do |suit|
      RANKS.map do |rank|
        PlayingCard.new(rank, suit)
      end
    end
  end

  def cards_left
    cards.count
  end

  def deal
    cards.pop
  end
end
