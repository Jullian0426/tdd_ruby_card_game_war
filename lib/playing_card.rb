class PlayingCard
  attr_reader :rank, :suit, :numerical_rank

  RANKS = %w(2 3 4 5 6 7 8 9 10 J Q K A)

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @numerical_rank = RANKS.index(rank)
  end

  def ==(other_card)
    other_card.rank == rank && other_card.suit == suit
  end

  def beat?(other_card)
    if numerical_rank > other_card.numerical_rank
      return true
    elsif other_card.numerical_rank > numerical_rank
      return false
    end
  end
end