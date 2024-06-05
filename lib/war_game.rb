# frozen_string_literal: true

require_relative 'card_deck'
require_relative 'war_player'

# Represents a card game of War
class WarGame
  attr_accessor :player1, :player2, :players, :deck, :winner, :tied_cards, :round_state

  def initialize(player1 = WarPlayer.new('Player 1'), player2 = WarPlayer.new('Player 2'), deck = CardDeck.new)
    @player1 = player1
    @player2 = player2
    @deck = deck
    @players = [player1, player2]
    @winner = nil
    @tied_cards = []
    @round_state = ""
  end

  def start
    deck.cards.shuffle!
    until deck.cards_left.zero?
      player1.take(deck.deal)
      player2.take(deck.deal)
    end
  end

  def play_round
    p1_card, p2_card = players.map(&:play)
    self.round_state +=
      "\nPlayer 1 plays #{p1_card.rank} of #{p1_card.suit}\n
      Player 2 plays #{p2_card.rank} of #{p2_card.suit}"
    winning_player = round_winner(p1_card, p2_card)
    round_handler(winning_player, p1_card, p2_card)
    game_over?
  end

  def round_winner(p1_card, p2_card)
    result = p1_card.beat?(p2_card)
    if result == true
      player1
    else
      (result == false ? player2 : :tie)
    end
  end

  def round_handler(winning_player, p1_card, p2_card)
    if winning_player == :tie
      tied_cards << p1_card << p2_card
      self.round_state += "It's a tie! Cards go to tied pool."
      play_round until game_over?
    else
      winning_player.take([p1_card, p2_card] + tied_cards)
      tied_cards.clear
      self.round_state += "\n#{winning_player.name} wins this round."
    end
  end

  def game_over?
    if player1.cards.empty?
      self.winner = player2
    elsif player2.cards.empty?
      self.winner = player1
    end
  end
end
