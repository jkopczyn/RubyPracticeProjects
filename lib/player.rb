require 'hand'
require 'byebug'

class Player
  attr_reader :bankroll, :hand

  RANK_HASH = { '2' => :two, '3' => :three, '4' => :four, '5' => :five, '6' => :six,
    '7' => :seven, '8' => :eight, '9' => :nine, 't' => :ten, 'j' => :jack,
    'q' => :queen, 'k' => :king, 'a' => :ace }
  SUIT_HASH = { 'c' => :clubs, 'h' => :hearts, 's' => :spades,
           'd' => :diamonds }

  def initialize(bankroll, hand)
    @bankroll, @hand = bankroll, hand
  end

  def draw_hand(deck)
    @hand = deck.deal_cards(5)
  end

  def replace_cards(user_cards, deck)
    discarding_cards = user_cards.map { |card| parse_card(card) }
    hand_indices = discarding_cards.map do |card|
      hand.cards.find_index do |hand_card|
        hand_card.rank == card[:rank] && hand_card.suit == card[:suit]
      end
    end
    raise "card not in hand" unless hand_indices.all?
    hand.discard!(hand_indices)
    #debugger
    hand.receive_cards(deck.deal_cards(hand_indices.length))
  end



  def bet(bet)
    raise "Bet exceeds bankroll" if bet > bankroll
    raise "Bet/raise must be a positive number" if bet < 0
    @bankroll -= bet

    bet
  end

  def take_winnings(pot)
    @bankroll += pot
  end

  def display_hand
    puts @hand.cards.map { |card| card_to_s(card) }.join(" ")
  end

  def display_message(message)
    puts message
  end

  def make_bet(current_bet, player_current_bet)
    display_hand
    begin
      puts "The bet stands at #{current_bet}. You have bet #{player_current_bet}"
      puts "Call, raise, or fold?"
      user_input = gets.chomp.downcase
      raise "invalid input" unless ["raise", "call", "fold"].include?(user_input)
    rescue
      retry
    end
    case user_input
    when "fold"
      return :fold
    when "call"
      bet(current_bet - player_current_bet)
    when "raise"
      begin
        puts "How much do you want to raise by?"
        raise_amt = Integer(gets.chomp)
      rescue
        puts "Please enter Arabic numerals."
        retry
      end
      bet(current_bet - player_current_bet + raise_amt)
    end
  end

  def take_new_cards(deck)
    display_cards
    puts "How many cards do you want to replace?"
    cards_to_replace = []
    num_to_replace = Integer(gets.chomp)
    until cards_to_replace.count >= num_to_replace do
      puts "Name the card you want to replace:"
      new_card = gets.chomp
      if new_card.length == 2
        cards_to_replace << new_card
      else
        puts "wrong format"
        next
      end
    end
    replace_cards(cards_to_replace, deck)
  rescue
    retry
  end

  private

  def parse_card(card_str)
    rank_char, suit_char = card_str.downcase.split("")

    rank = RANK_HASH[rank_char]
    suit = SUIT_HASH[suit_char]
    raise "Invalid Input" unless [rank, suit].all?

    { rank: rank, suit: suit }
  end

  def card_to_s(card)
    RANK_HASH.invert[card.rank] + SUIT_HASH.invert[card.suit]
  end
end
