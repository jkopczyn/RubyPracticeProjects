require 'rspec'
require 'card'

describe Card do
  describe '#initialize' do

    it "takes a rank and a suit" do
      card = Card.new(:ten,:clubs)
      expect(card.rank).to eq :ten
      expect(card.suit).to eq :clubs
    end

    it "raises an error for invalid input" do
      expect { Card.new(:eleven,:clubs) }.to raise_error "Invalid rank"
      expect { Card.new }.to raise_error
      expect { Card.new(:seven, :jack) }.to raise_error "Invalid suit"
      expect { Card.new(:eight) }.to raise_error ArgumentError
    end
  end

  describe '#<=>' do
    let(:two_of_hearts) {Card.new(:two,:hearts)}
    let(:two_of_spades) {Card.new(:two,:spades)}
    let(:ten_of_spades) {Card.new(:ten,:spades)}
    let(:jack_of_hearts) {Card.new(:jack,:hearts)}
    let(:queen_of_hearts) {Card.new(:queen,:hearts)}
    let(:king_of_hearts) {Card.new(:king,:hearts)}
    let(:ace_of_hearts) {Card.new(:ace,:hearts)}

    it "compares numbered cards" do
      expect(two_of_hearts <=> two_of_hearts).to be 0
      expect(two_of_hearts <=> two_of_spades).to be 0
      expect(two_of_hearts <=> ten_of_spades).to be -1
      expect(ten_of_spades <=> two_of_spades).to be 1
    end

    it "values honors higher than numbers" do
      expect(ten_of_spades).to be < jack_of_hearts
      expect(ten_of_spades).to be < queen_of_hearts
      expect(ten_of_spades).to be < king_of_hearts
      expect(ten_of_spades).to be < ace_of_hearts
    end

    it "orders honors correctly" do
      expect(jack_of_hearts).to be < queen_of_hearts
      expect(queen_of_hearts).to be < king_of_hearts
      expect(king_of_hearts).to be < ace_of_hearts
      expect(ace_of_hearts).to be > jack_of_hearts
    end
  end

  describe '#same_suit?' do
    let(:spade) { Card.new(:three, :spades) }
    let(:another_spade) { Card.new(:four, :spades) }
    let(:heart) { Card.new(:seven, :hearts)}

    it "recognizes two cards of the same suit" do
      expect(spade.same_suit?(spade)).to be true
      expect(spade.same_suit?(another_spade)).to be true
    end

    it "recognizes two cards of different suits" do
      expect(spade.same_suit?(heart)).to be false
    end
  end
end
