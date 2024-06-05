# frozen_string_literal: true

# Represents a player in the game of War.
class WarPlayer
  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end

  def take(taken_cards)
    taken_cards.shuffle! if taken_cards.respond_to? :shuffle
    cards.push(*taken_cards)
  end

  def play
    cards.shift
  end
end
