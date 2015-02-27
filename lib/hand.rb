require 'deck'
class Hand
  include Comparable
  include Enumerable

  def initialize(cards)
    @cards = cards
  end

  def each
    @cards.each
  end

  def <=>(other)
    -1
  end

end
