
describe "#draw_cards" do
  let_cards
  let(:small_flush) { Hand.new([two_of_hearts, three_of_hearts,
    four_of_hearts]) }
  let(:deck) { double("deck") }
  let(:some_cards) { [Card.new(:nine, :spades), Card.new(:jack, :spades),
                 Card.new(:seven, :hearts)] }
  it "should receive cards from the deck" do
    expect(deck).to receive(:deal_cards).with(*args).and_return some_cards.take(args[0])
    small_flush.draw_cards(2, deck)

    expect(small_flush.length).to eq 5
    expect(small_flush.cards.include?(some_cards[0])).to be true
    expect(small_flush.cards.include?(some_cards[1])).to be true
  end
end
