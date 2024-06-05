# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/card_deck'

describe 'CardDeck' do
  it 'Should have 52 cards when created' do
    deck = CardDeck.new
    expect(deck.cards_left).to eq 52
  end

  it 'should deal the top card' do
    deck = CardDeck.new
    card = deck.deal
    expect(card).to_not be_nil
    expect(card).to respond_to :rank
    expect(deck.cards_left).to eq 51
  end

  it 'should deal unique cards' do
    deck = CardDeck.new
    card1 = deck.deal
    card2 = deck.deal
    expect(card1).to_not eq card2
  end
end
