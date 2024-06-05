# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/war_player'

describe 'WarPlayer' do
  describe '#initialize' do
    it 'should initialize with name and empty cards array' do
      player = WarPlayer.new('Player')

      expect(player.name).to eq 'Player'
      expect(player.cards).to eq []
    end
  end

  describe '#take' do
    it 'should add a card to the end of the cards array' do
      player = WarPlayer.new('Player')
      card = PlayingCard.new('2', 'H')
      player.take(card)

      expect(player.cards).to include(card)
    end
  end

  describe '#play' do
    it 'should remove and return the first element of the cards array' do
      player = WarPlayer.new('Player')
      card1 = PlayingCard.new('2', 'H')
      card2 = PlayingCard.new('3', 'C')
      player.take(card1)
      player.take(card2)

      played_card = player.play

      expect(played_card).to eq card1
      expect(player.cards).to_not include(card1)
    end
  end
end
