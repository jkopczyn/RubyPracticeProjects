require 'deck'

class Hand
  attr_reader :cards
  include Comparable
  include Enumerable

  def self.new_hand(deck)
    Hand.new(deck.deal_cards(5))
  end

  def initialize(cards)
    @cards = cards.sort
  end

  def receive_cards(new_cards)
    @cards += new_cards
  end

  def length
    @cards.length
  end

  #used for side effect, not return value
  def discard!(indices)
    discarded = []
    indices.each do |idx|
      raise StandardError("Index larger than hand") if idx >= length
      discarded << @cards[idx]
      @cards[idx] = nil
    end
    @cards.compact!
    discarded
  end

  def each
    @cards.each
  end

  def <=>(other)
    -1
  end

end
