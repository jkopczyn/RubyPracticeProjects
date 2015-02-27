class Card
  include Comparable
  attr_reader :rank, :suit

  RANKS = [:two, :three, :four, :five, :six, :seven, :eight, :nine, :ten,
           :jack, :queen, :king, :ace]
  SUITS = [:clubs, :hearts, :spades, :diamonds]

  def initialize(rank, suit)
    raise 'Invalid rank' unless RANKS.include? rank
    raise 'Invalid suit' unless SUITS.include? suit
    @rank = rank
    @suit = suit
  end

  def <=>(other)
    RANKS.find_index(rank) <=> RANKS.find_index(other.rank)
  end

  def same_suit?(other_card)
    suit == other_card.suit
  end
end
