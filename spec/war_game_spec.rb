require_relative '../lib/war_game'

describe 'WarGame' do
  describe '#initialize' do
    it 'should initialize with players and deck' do
      player1 = WarPlayer.new("Player 1")
      player2 = WarPlayer.new("Player 2")

      game = WarGame.new(player1, player2)

      expect(game).to respond_to :player1
      expect(game).to respond_to :player2
      expect(game).to respond_to :deck
    end
  end

  describe '#start' do
    it 'should shuffle the deck' do
      player1 = WarPlayer.new("Player 1")
      player2 = WarPlayer.new("Player 2")

      game1 = WarGame.new(player1, player2)
      game2 = WarGame.new(player1, player2)
      game2.start

      expect(game2.deck.cards).to_not eq game1.deck.cards
    end

    it 'should deal cards to each player until deck is empty' do
      player1 = WarPlayer.new("Player 1")
      player2 = WarPlayer.new("Player 2")

      game = WarGame.new(player1, player2)
      half_of_deck = (game.deck.cards_left / 2).floor
      game.start

      expect(player1.cards.size).to eq half_of_deck
      expect(player1.cards.size).to eq half_of_deck
      expect(game.deck.cards_left).to eq 0
    end
  end

  describe '#play_round' do
    it 'should handle ties properly' do
      card1 = PlayingCard.new('A', 'H')
      card2 = PlayingCard.new('A', 'C')
      card3 = PlayingCard.new('6', 'D')
      card4 = PlayingCard.new('3', 'D')

      player1 = WarPlayer.new("Player 1")
      player1.take(card1)
      player1.take(card3)
      player2 = WarPlayer.new("Player 2")
      player2.take(card2)
      player2.take(card4)

      game = WarGame.new(player1, player2)
      game.play_round

      expect(player1.cards.size).to eq 4
      expect(player2.cards.size).to eq 0
    end

    let(:winning_card) { PlayingCard.new('A', 'H') }
    let(:losing_card) { PlayingCard.new('2', 'H') }
    let(:player1) { WarPlayer.new("Player 1") }
    let(:player2) { WarPlayer.new("Player 2") }
    let(:game) { WarGame.new(player1, player2) }

    before do
      player1.take(winning_card)
      player2.take(losing_card)
    end

    describe '#compare_ranks' do
      it 'should return player1 if player1 wins' do
        p1_rank = player1.play.rank
        p2_rank = player2.play.rank
        result = game.test_compare_ranks(p1_rank, p2_rank)

        expect(result).to eq player1
      end
    end
    
    it 'should give player1 both cards when they win the round' do
      game.play_round

      expect(player1.cards.size).to eq 2
      expect(player2.cards.size).to eq 0
    end

    it 'should declare winner if a player has no cards' do
      game.play_round

      expect(game.winner).to eq player1
    end
  end
end