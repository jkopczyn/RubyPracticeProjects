require 'rspec'
require 'deck'

describe Deck do
  describe '#initialize' do
    let(:some_cards) { [Card.new(:ten, :spades), Card.new(:queen, :hearts)] }

    it 'takes a list of cards to make a new deck' do
      test_deck = Deck.new(some_cards)
      expect(test_deck.cards).to eq(some_cards)
    end

    it 'generates a standard deck if not given one' do
      test_deck = Deck.new
      expect(test_deck.cards.count).to be 52
      expect(test_deck.cards.uniq.count).to be 52
    end
  end

  describe '#shuffle!' do
    subject(:deck) { Deck.new }

    it "reorders the deck" do
      original_cards = deck.cards.dup
      deck.shuffle!
      expect(deck.cards).not_to eq(original_cards)
      expect(deck.cards.sort).to eq(original_cards.sort)
    end
  end

  describe '#deal_cards' do
    let(:some_cards) { [Card.new(:ten, :spades), Card.new(:queen, :hearts)] }
    subject(:small_deck) { Deck.new(some_cards) }

    it "can deal a single card" do
      top_card = small_deck.cards.first
      expect(small_deck.deal_cards(1)).to eq [top_card]
      expect(small_deck.cards.count).to eq 1
    end

    it "can deal multiple cards" do
      deck_copy = some_cards.dup
      expect(small_deck.deal_cards(2)).to eq deck_copy
      expect(small_deck.cards).to be_empty
    end

    it "can't deal more cards than in the deck" do
      expect { small_deck.deal_cards(3) }.to raise_error
    end
  end
end
