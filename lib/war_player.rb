 class WarPlayer
  attr_accessor :name, :cards
  
  def initialize(name)
    @name = name
    @cards = []
  end

  def take(taken_cards)
    taken_cards = [taken_cards] unless taken_cards.is_a?(Array)
    taken_cards.shuffle!
    cards.push(*taken_cards)
  end

  def play
    cards.shift
  end
 end