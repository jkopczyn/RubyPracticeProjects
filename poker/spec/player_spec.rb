require 'rspec'
require 'player'

describe Player do
  describe '#initialize' do
    let(:hand) { double("hand", {cards: [1,2,3,4,5]}) }
    let(:bankroll) { 0 }

    it "can take a new hand and bankroll" do
      test_player = Player.new(bankroll, hand)
      expect(test_player.hand).to be hand
      expect(test_player.bankroll).to be bankroll
    end

    it "raises an error with incomplete arguments" do
      expect { Player.new(bankroll) }.to raise_error(ArgumentError)
      expect { Player.new(hand) }.to raise_error(ArgumentError)
      expect { Player.new() }.to raise_error(ArgumentError)
    end
  end

  describe '#draw_hand' do
    let(:cards) { double("card_array") }
    let(:deck) { double("deck") }
    subject(:player) { Player.new(0,cards) }

    it "puts cards from the deck into its hand" do
      expect(deck).to receive(:deal_cards).and_return(cards)
      player.draw_hand(deck)
      expect(player.hand).to be cards
    end
  end

  describe '#replace_cards' do
    let_cards
    let(:hand) { Hand.new([two_of_clubs, four_of_diamonds, queen_of_spades,
                           five_of_diamonds, ace_of_hearts]) }
    let(:bankroll) { 0 }
    let(:deck) { double("deck") }
    subject(:player) { Player.new(bankroll, hand) }
    let(:two_cards) { [ace_of_spades, seven_of_hearts] }

    it 'should raise error if cards are not in the hand' do
      expect { replace_cards(["3S", "AH"], deck) }.to raise_error
    end

    it "should remove indicated cards from its hand" do
      allow(deck).to receive(:deal_cards).and_return(two_cards)

      player.replace_cards(["2C", "AH"], deck)
      expect(player.hand.include?(ace_of_hearts)).to be false
      expect(player.hand.include?(two_of_clubs)).to be false
    end

    it "should remove only indicated cards" do
      allow(deck).to receive(:deal_cards).and_return(two_cards)
      player.replace_cards(["2C", "AH"], deck)
      expect(player.hand.include?(queen_of_spades)).to be true
      expect(player.hand.include?(four_of_diamonds)).to be true
      expect(player.hand.include?(five_of_diamonds)).to be true
    end

    it "should stay the same if given no cards to replace" do
      allow(deck).to receive(:deal_cards).with(0).and_return([])
      player.replace_cards([],deck)
      expect(player.hand).to eq hand
    end

    it "should end with five cards" do
      allow(deck).to receive(:deal_cards).and_return(two_cards)
      player.replace_cards(["2C", "AH"], deck)
      expect(player.hand.count).to be 5
    end

    it "should draw from a deck" do
      expect(deck).to receive(:deal_cards).with(1).and_return([three_of_diamonds])
      player.replace_cards(["2C"], deck)
    end
  end

  describe '#bet' do
    let(:hand) { Hand.new([1,2,3,4,5]) }
    let(:bankroll) { 400 }
    subject(:player) { Player.new(bankroll, hand) }

    it "should reduce the bankroll" do
      player.bet(300)
      expect(player.bankroll).to be 100
    end

    it "should not reduce bankroll below 0" do
      expect { player.bet(500) }.to raise_error "Bet exceeds bankroll"
    end

    it "should not allow negative bets" do
      expect { player.bet(-50) }.to raise_error
    end

    it "should return the value of the bet" do
      expect(player.bet(350)).to eq 350
    end
  end

  describe '#take_winnings' do
    let(:hand) { Hand.new([1,2,3,4,5]) }
    let(:bankroll) { 400 }
    subject(:player) { Player.new(bankroll, hand) }

    it "adds winnings to bankroll" do
      player.take_winnings(300)
      expect(player.bankroll).to be 700
    end
  end

end
