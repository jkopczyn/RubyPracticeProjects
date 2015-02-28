require 'rspec'
require 'game'

describe Game do

  describe '#initialize' do
    let(:players) { Array.new(3) { double("player") } }
    let(:deck) { double("deck") }
    subject(:game) { Game.new(players, deck) }

    it 'takes a list of players and a deck' do
      expect(game.players).to be(players)
      expect(game.deck).to be(deck)
    end

    it 'raises an error without correct arguments' do
      expect { Game.new(5) }.to raise_error(ArgumentError)
      expect { Game.new }.to raise_error(ArgumentError)
    end

    it 'has a pot that starts at 0' do
      expect(game.pot).to be 0
    end

    it "initializes each player's bet to 0" do
      game.players.each { |player| expect(game.bets[player]).to be 0 }
    end
  end

  describe '#betting_round' do
    let(:players) do
      Array.new(3) do |i|
        normal = double("player#{i}")
        allow(normal).to receive(:make_bet).and_return(0)

        normal
      end
    end
    let(:folding_player) do
      folder = double("player")
      allow(folder).to receive(:make_bet).and_return(:fold)

      folder
    end
    let(:deck) { double("deck") }
    subject(:game) { Game.new(players, deck) }

    it "asks players for bets" do
      game.players.each { |player| expect(player).to receive(:make_bet) }
      game.betting_round
    end

    it "should end with all bets equal" do
      game.betting_round
      game.players.each do |player|
        expect(game.bets[player]).to eq game.bets[players.first]
      end
    end

    it "should drop players that fold" do
      game.players << folding_player
      game.betting_round
      expect(game.players.include?(folding_player)).to be false
    end
  end

  describe '#draw_new_cards' do
    let(:players) { Array.new(3) { double("player") } }
    let(:deck) { double("deck") }
    subject(:game) { Game.new(players, deck) }

    it "offers each player to replace cards" do
      game.players.each do |player|
        expect(player).to receive(:take_new_cards).with(deck)
      end
      game.draw_new_cards
    end
  end

  describe '#winners' do
    let(:player1) { Player.new(0, 0) }
    let(:player2) { Player.new(0, 3) }
    let(:player3) { Player.new(0, 2) }
    let(:tied_player) { Player.new(0, 3) }
    let(:players) { [player1, player2, player3] }
    let(:players_with_tie) { players + [tied_player] }
    let(:deck) { double("deck") }
    let(:game_without_tie) { Game.new(players, deck) }
    let(:game_with_tie) { Game.new(players_with_tie, deck) }

    it "finds the winner when there is one winner" do
      expect(game_without_tie.winners).to eq([player2])
    end

    it "finds the winner with a tie" do
      expect(game_with_tie.winners).to eq([player2, tied_player])
    end
  end
end
