 class WarPlayer
  attr_accessor :name, :cards
  
  def initialize(name)
    @name = name
    @cards = []
  end

  def take(card)
    cards.push(card)
  end

  def play
    cards.shift
  end
 end