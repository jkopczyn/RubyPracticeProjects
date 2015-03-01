require 'deck'

class Hand
  attr_reader :cards
  include Comparable

  HAND_ORDER = {straight_flush: 9, four_of_a_kind: 8, full_house: 7,
                flush: 6, straight: 5, three_of_a_kind: 4,
                two_pair: 3, pair: 2, high_card: 1}

  def self.new_hand(deck)
    Hand.new(deck.deal_cards(5))
  end

  def initialize(cards)
    @cards = cards.sort.reverse
  end

  def receive_cards(new_cards)
    @cards += new_cards
    sort!
  end

  def length
    cards.length
  end

  def sort! #sort is intentionally not defined
    @cards = cards.sort.reverse
  end

  def sort
    Hand.new(cards).sort!
  end

  def count
    cards.count
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

  def include?(card)
    cards.map { |other_card| card.same_suit?(other_card) &&
          0 == (card <=> other_card) }.any?
  end

  def each
    @cards.each
  end


  def remove_rank(rank)
    Hand.new(cards.dup.reject { |elem| elem.rank == rank})
  end

  def <=>(other)
    hand_compare = HAND_ORDER[hand_type] <=> HAND_ORDER[other.hand_type]
    return hand_compare unless hand_compare == 0
    case hand_type
    when :straight_flush, :flush, :straight, :high_card
      compare_cards_in_order(other)
    when :four_of_a_kind, :three_of_a_kind, :pair
      test_max_sets(other)
    when :full_house, :two_pair
      test_full_house_or_two_pair(other)
    else
      raise "comparison broke for some reason."
    end
  end

  def test_max_sets(other)
    set_compare = most_common_card <=> other.most_common_card
    return set_compare unless set_compare == 0
    remove_rank(most_common_card.rank).compare_cards_in_order(
                other.remove_rank(other.most_common_card.rank))
  end

  def test_full_house_or_two_pair(other)
    set_compare = most_common_card <=> other.most_common_card
    return set_compare unless set_compare == 0
    remove_rank(most_common_card.rank).test_max_sets(
                other.remove_rank(other.most_common_card.rank))
  end

  def compare_cards_in_order(other)
    cards.compare_in_order(other.cards)
  end

  def is_straight?
    self.sort!
    (length-1).times do |index|
      return false unless cards[index+1].next_rank?(cards[index])
    end

    true
  end

  def is_flush?
    cards.all? { |card| card.same_suit?(cards.first)}
  end

  def max_set
    self.sort!
    max_num = 1
    cards.each do |card|
      count = cards.count { |other_card| other_card.rank == card.rank }
      max_num = [max_num, count].max
    end

    max_num
  end

  def most_common_card
    self.sort!
    max_num = 0
    common_card = nil
    cards.each do |card|
      count = cards.count { |other_card| other_card.rank == card.rank }
      if count > max_num || (count == max_num && card > common_card)
        max_num = count
        common_card = card
      end
    end

    common_card
  end

  def hand_type
    straight = is_straight?
    flush = is_flush?
    max_set = self.max_set
    if straight && flush
      :straight_flush
    elsif max_set == 4
      :four_of_a_kind
    elsif full_house?
      :full_house
    elsif flush
      :flush
    elsif straight
      :straight
    elsif max_set == 3
      :three_of_a_kind
    elsif two_pair? #TODO
      :two_pair
    elsif max_set == 2
      :pair
    else
      :high_card
    end
  end

  def full_house?
    mid_rank = cards[2].rank
    other_cards = cards.reject { |card| card.rank == mid_rank }
    other_cards.length == 2 && (other_cards[0].rank == other_cards[1].rank)
  end

  def two_pair?
    return false if max_set > 2
    one_pair = false
    cards.each_index do |index|
      (index+1...cards.length).each do |second_index|
        if cards[index].rank == cards[second_index].rank
          if one_pair
            return true
          else
            one_pair = true
            break
          end
        end
      end
    end

    false
  end
end


class Array
  def compare_in_order(other)
    length.times do |index|
      comparison = self[index] <=> other[index]
      return comparison unless comparison == 0
    end
    0
  end
end
