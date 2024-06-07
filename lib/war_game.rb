# frozen_string_literal: true

require_relative 'card_deck'
require_relative 'war_player'

# Represents a card game of War
class WarGame
  attr_accessor :players, :deck, :winner, :tied_cards, :round_state

  def initialize(players = [WarPlayer.new('Player 1'), WarPlayer.new('Player 2')], deck = CardDeck.new)
    @deck = deck
    @players = players
    @winner = nil
    @tied_cards = []
    @round_state = ''
  end

  def start
    deck.cards.shuffle!
    until deck.cards_left.zero?
      players[0].take(deck.deal)
      players[1].take(deck.deal)
    end
  end

  def round_state_message(played_cards)
    "#{players[0].name} plays #{played_cards[0].rank} of #{played_cards[0].suit}\n#{players[1].name} plays #{played_cards[1].rank} of #{played_cards[1].suit}"
  end

  def play_round
    played_cards = players.map(&:play)
    self.round_state += round_state_message(played_cards)
    winning_player = round_winner(played_cards[0], played_cards[1])
    round_handler(winning_player, played_cards[0], played_cards[1])
    game_over?
  end

  def round_winner(p1_card, p2_card)
    result = p1_card.beat?(p2_card)
    if result == true
      players[0]
    else
      (result == false ? players[1] : :tie)
    end
  end

  def round_handler(winning_player, p1_card, p2_card)
    if winning_player == :tie
      handle_tie(p1_card, p2_card)
    else
      handle_round_winner(winning_player, p1_card, p2_card)
    end
  end

  def handle_tie(p1_card, p2_card)
    tied_cards << p1_card << p2_card
    self.round_state += "\nIt's a tie! Cards go to tied pool.\n"
    play_round
  end

  def handle_round_winner(winning_player, p1_card, p2_card)
    winning_player.take([p1_card, p2_card] + tied_cards)
    tied_cards.clear
    self.round_state += "\n#{winning_player.name} wins this round."
  end

  def game_over?
    if players[0].cards.empty?
      self.winner = players[1]
    elsif players[1].cards.empty?
      self.winner = players[0]
    end
  end
end
