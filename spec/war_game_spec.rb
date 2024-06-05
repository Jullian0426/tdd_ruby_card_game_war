# frozen_string_literal: true

require_relative '../lib/war_game'

describe 'WarGame' do
  describe '#initialize' do
    it 'should initialize with players and deck' do
      game = WarGame.new

      expect(game).to respond_to :players
      expect(game).to respond_to :deck
    end
  end

  describe '#start' do
    it 'should shuffle the deck' do
      game1 = WarGame.new
      game2 = WarGame.new
      game2.start

      expect(game2.deck.cards).to_not eq game1.deck.cards
    end

    it 'should deal cards to each player until deck is empty' do
      game = WarGame.new
      half_of_deck = (game.deck.cards_left / 2).floor
      game.start

      expect(game.players[0].cards.size).to eq half_of_deck
      expect(game.players[1].cards.size).to eq half_of_deck
      expect(game.deck.cards_left).to eq 0
    end
  end

  describe '#play_round' do
    it 'should handle ties properly' do
      card1 = PlayingCard.new('A', 'H')
      card2 = PlayingCard.new('A', 'C')
      card3 = PlayingCard.new('6', 'D')
      card4 = PlayingCard.new('3', 'D')

      game = WarGame.new
      game.players[0].cards = [card1, card3]
      game.players[1].cards = [card2, card4]
      game.play_round

      expect(game.players[0].cards.size).to eq 4
      expect(game.players[1].cards.size).to eq 0
    end

    let(:winning_card) { PlayingCard.new('A', 'H') }
    let(:losing_card) { PlayingCard.new('2', 'H') }
    let(:game) { WarGame.new }

    before do
      game.players[0].take(winning_card)
      game.players[1].take(losing_card)
    end

    it 'should give Player 1 both cards when they win the round' do
      game.play_round

      expect(game.players[0].cards.size).to eq 2
      expect(game.players[1].cards.size).to eq 0
    end

    it 'should declare winner if a player has no cards' do
      game.play_round

      expect(game.winner).to eq game.players[0]
    end
  end
end
