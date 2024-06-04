require_relative '../lib/playing_card'

describe 'PlayingCard' do
  describe "#==" do
    it "should only return true if ranks and suits are equivalent" do
      card1 = PlayingCard.new('2', 'H')
      card2 = PlayingCard.new('2', 'H')
      card3 = PlayingCard.new('3', 'H')
      card4 = PlayingCard.new('2', 'C')

      expect(card1).to eq card2
      expect(card1).to_not eq card3
      expect(card1).to_not eq card4
    end
  end

  describe '#beat_card?' do
    let(:winning_card) { PlayingCard.new('A', 'H') }
    let(:losing_card) { PlayingCard.new('2', 'H') }

    it "should return true if higher rank" do
      result = winning_card.beat?(losing_card)

      expect(result).to eq true
    end
  end
end
