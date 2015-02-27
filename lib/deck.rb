require_relative 'card'

class Deck
  attr_reader :cards

  def self.new_deck
    [].tap do |deck|
      Card::RANKS.each do |rank|
        Card::SUITS.each do |suit|
          deck << Card.new(rank, suit)
        end
      end
    end
  end

  def initialize(cards = nil)
    @cards = cards
    @cards ||= Deck.new_deck
  end

  def shuffle!
    @cards.shuffle!
  end

  def deal_cards(n = 1)
    raise "can't deal more cards than in the deck" if n > @cards.length
    @cards.shift(n)
  end
end
