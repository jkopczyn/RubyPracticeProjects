require 'rspec'
require 'hand'

describe Hand do
  describe '::new_hand' do
    it 'creates a new hand of five cards' do
      deck = Deck.new.shuffle!
      test_hand = Hand.new_hand(deck)
      expect(test_hand.length).to be 5
      expect(deck.size).to be 47
      expect(test_hand.uniq.length).to be 5
    end
  end

  describe '#initialize' do
    let(:some_cards) { [Card.new(:ten, :spades), Card.new(:queen, :hearts)] }

    it 'creates a hand from a list of cards' do
      test_hand = Hand.new(some_cards)
      expect(test_hand.cards).to eq some_cards
    end
  end

  describe '#discard' do
    let_cards
    let(:straight_flush_to_six) { Hand.new([two_of_hearts, three_of_hearts,
      four_of_hearts, five_of_hearts, six_of_hearts]) }
    it "should discard one card" do
      copy = straight_flush_to_six.cards.dup
      expect(straight_flush_to_six.discard([3])).to eq([copy[3]])
      expect(straight_flush_to_six.length).to be 4
    end

    it "should discard multiple cards" do
      copy = straight_flush_to_six.cards.dup
      expect(straight_flush_to_six.discard([3, 2, 4])).to eq([copy[3], copy[2], copy[4]])
      expect(straight_flush_to_six.length).to be 2
    end

    it "should raise an error if index out of range" do
      expect { straight_flush_to_six.discard([5]) }.to raise_error
    end
  end

  describe '#receive_cards' do
    let_cards
    let(:small_flush) do
      Hand.new([two_of_hearts, three_of_hearts, four_of_hearts])
    end
    let(:some_cards) { [Card.new(:nine, :spades), Card.new(:jack, :spades)] }
    it "adds supplied cards to the hand" do
      small_flush.receive_cards(some_cards)
      expect(small_flush.length).to be 5
      expect(small_flush).to_include some_cards[0]
      expect(small_flush).to_include some_cards[1]
    end
  end

  describe '#<=>' do
    let_cards
    let(:straight_flush_to_six) { Hand.new([two_of_hearts, three_of_hearts,
      four_of_hearts, five_of_hearts, six_of_hearts]) }

    let(:four_jacks_and_nine) { Hand.new([jack_of_hearts, jack_of_spades,
      jack_of_diamonds, jack_of_clubs, nine_of_spades]) }
    let(:four_jacks_and_six) { Hand.new([jack_of_hearts, jack_of_spades,
      jack_of_diamonds, jack_of_clubs, six_of_clubs]) }

    let(:aces_over_threes) { Hand.new([ace_of_hearts, ace_of_spades,
      ace_of_clubs, three_of_diamonds, three_of_hearts]) }
    let(:queens_over_tens) { Hand.new([queen_of_hearts, ten_of_hearts,
      queen_of_spades, queen_of_clubs, ten_of_clubs]) }

    let(:flush_king_high) { Hand.new([seven_of_hearts, three_of_hearts,
      four_of_hearts, king_of_hearts, six_of_hearts]) }
    let(:flush_ten_high) { Hand.new([seven_of_spades, two_of_spades,
      five_of_spades, ten_of_spades, four_of_spades]) }

    let(:straight_to_eight) { Hand.new([seven_of_hearts, eight_of_hearts,
      four_of_spades, five_of_clubs, six_of_hearts]) }
    let(:straight_to_six) { Hand.new([two_of_hearts, three_of_hearts,
      four_of_spades, five_of_clubs, six_of_hearts]) }

    let(:three_threes) { Hand.new([three_of_clubs, three_of_hearts,
      three_of_spades, five_of_hearts, six_of_hearts]) }
    let(:three_queens) { Hand.new([queen_of_hearts, queen_of_spades,
      queen_of_clubs, five_of_clubs, two_of_hearts]) }

    let(:kings_and_nines_and_jack) { Hand.new([king_of_hearts, nine_of_hearts,
      king_of_clubs, nine_of_clubs, jack_of_diamonds]) }
    let(:kings_and_nines_and_eight) { Hand.new([king_of_hearts, nine_of_hearts,
      king_of_clubs, nine_of_clubs, eight_of_diamonds]) }
    let(:kings_and_sevens_and_queen) { Hand.new([king_of_hearts, seven_of_hearts,
      king_of_clubs, seven_of_clubs, queen_of_diamonds]) }
    let(:queens_and_jacks) { Hand.new([queen_of_hearts, jack_of_hearts,
      king_of_clubs, queen_of_clubs, jack_of_diamonds]) }

    let(:two_kings_and_a_queen) { Hand.new([king_of_hearts, nine_of_hearts,
      king_of_clubs, queen_of_clubs, two_of_diamonds]) }
    let(:two_kings_and_a_seven) { Hand.new([king_of_hearts, seven_of_hearts,
      two_of_clubs, king_of_clubs, four_of_diamonds]) }
    let(:two_queens_and_an_ace) { Hand.new([ace_of_hearts, seven_of_hearts,
      queen_of_clubs, six_of_clubs, queen_of_diamonds]) }

    let(:ace_ten_nine) { Hand.new([ace_of_hearts, nine_of_clubs,
      four_of_spades, ten_of_clubs, six_of_hearts]) }
    let(:ace_eight_seven) { Hand.new([ace_of_hearts, eight_of_hearts,
      seven_of_hearts, five_of_clubs, six_of_spades]) }
    let(:king_queen_jack) { Hand.new([king_of_hearts, eight_of_hearts,
      seven_of_hearts, queen_of_clubs, jack_of_spades]) }

    context "correct ordering of hands" do
      it "straight flush beats four of a kind" do
        expect(straight_flush_to_six).to be > four_jacks_and_nine
      end

      it "kicker for four of a kind" do
        expect(four_jacks_and_nine).to be > four_jacks_and_six
      end

      it "four of a kind beats full house" do
        expect(four_jacks_and_six).to be > aces_over_threes
      end

      it "sorts full houses by three of a kind" do
        expect(aces_over_threes).to be > queens_over_tens
      end

      it "full house beats flush" do
        expect(queens_over_tens).to be > flush_king_high
      end

      it "flush sorts by high card" do
        expect(flush_king_high).to be > flush_ten_high
      end

      it "flush beats straight" do
        expect(flush_ten_high).to be > straight_to_eight
      end

      it "sorts straights by high card" do
        expect(straight_to_eight).to be > straight_to_six
      end

      it "straight beats three of a kind" do
        expect(straight_to_six).to be > three_queens
      end

      it "sorts three of a kind by three" do
        expect(three_queens).to be > three_threes
      end

      it "three of a kind beats two pair" do
        expect(three_threes).to be > kings_and_nines_and_jack
      end

      it "sorts two pair by high pair" do
        expect(kings_and_nines_and_jack).to be > queens_and_jacks
      end

      it "sorts two pair tied on high pair by low pair" do
        expect(kings_and_nines_and_jack).to be > kings_and_sevens_and_queen
      end

      it "sorts two tied pairs by kicker" do
        expect(kings_and_nines_and_jack).to be > kings_and_nines_and_eight
      end

      it "two pair beats one pair" do
        expect(queens_and_jacks).to be > two_kings_and_a_queen
      end

      it "sorts one pair by paired cards" do
        expect(two_kings_and_a_queen).to be > two_queens_and_an_ace
      end

      it "breaks ties in one pair by kicker" do
        expect(two_kings_and_a_queen).to be > two_kings_and_a_seven
      end

      it "one pair beats high card" do
        expect(two_queens_and_an_ace).to be > ace_ten_nine
      end

      it "ranks high card by high card" do
        expect(ace_ten_nine).to be > king_queen_jack
      end

      it "ranks high card ties by high cards" do
        expect(ace_ten_nine).to be > ace_eight_seven
      end
    end

    context "operator works in any order" do

      it "finds high hands on the left" do
        expect(straight_to_eight).to be > ace_ten_nine
      end

      it "finds high hands on the right" do
        expect(ace_ten_nine).to be < straight_to_eight
      end

      it "finds ties" do
        copy_pairs = Hand.new([king_of_clubs, nine_of_clubs,
          king_of_hearts, nine_of_hearts, jack_of_spades])
        expect(kings_and_nines_and_jack).to_not be < copy_pairs
        expect(kings_and_nines_and_jack).to_not be > copy_pairs
        expect(kings_and_nines_and_jack <=> copy_pairs).to be 0
      end
    end
  end

end
