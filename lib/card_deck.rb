# frozen_string_literal: true

require_relative 'playing_card'

# Represents a deck of playing cards.
class CardDeck
  attr_accessor :cards

  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  SUITS = %w[H D C S].freeze

  def initialize(cards = make_cards)
    @cards = cards
  end

  # Creates a new deck of playing cards.
  def make_cards
    SUITS.flat_map do |suit|
      RANKS.map do |rank|
        PlayingCard.new(rank, suit)
      end
    end
  end

  # Returns the number of cards left in the deck.
  def cards_left
    cards.count
  end

  # Deals a card from the top of the deck.
  def deal
    cards.pop
  end
end
