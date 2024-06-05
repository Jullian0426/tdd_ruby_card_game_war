# frozen_string_literal: true

# Represents a playing card in a deck.
class PlayingCard
  attr_reader :rank, :suit, :numerical_rank

  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @numerical_rank = RANKS.index(rank)
  end

  def ==(other)
    other.rank == rank && other.suit == suit
  end

  def beat?(other_card)
    if numerical_rank > other_card.numerical_rank
      true
    elsif other_card.numerical_rank > numerical_rank
      false
    end
  end
end
