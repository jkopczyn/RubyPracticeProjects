require 'player'
require 'deck'

class Game
  attr_reader :players, :bets, :pot, :deck

  def initialize(players,deck)
    @bets = {}
    @players = players
    players.each { |player| @bets[player] = 0 }
    @deck = deck
    @pot = 0
  end

  def betting_round
    max_bet = 0
    all_bet = false
    until all_bet && bets.values.all? { |bet| bet == max_bet }
      players.dup.each do |player|
        current_bet = player.make_bet(max_bet,bets[player])
        if current_bet == :fold
          players.delete(player)
          bets.delete(player)
          next
        else
          bets[player] += current_bet
          max_bet = bets[player]
        end
      end
      all_bet = true
    end
  end

  def draw_new_cards
    players.each { |player| player.take_new_cards(deck) }
  end

  def winners
    players.keep_if { |player| 0 == (player <=> players.max) }
  end
end
