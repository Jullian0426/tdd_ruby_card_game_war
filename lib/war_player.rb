 class WarPlayer
  attr_accessor :name, :cards
  
  def initialize(name, client = nil)
    @name = name
    @cards = []
    @client = client
  end

  def take(taken_cards)
    taken_cards.shuffle! if taken_cards.respond_to? :shuffle
    cards.push(*taken_cards)
  end

  def play
    cards.shift
  end
 end