require 'rspec'
require 'towers_of_hanoi'

describe TowersOfHanoi do

  describe '#initialize' do

    subject(:game) { TowersOfHanoi.new }

    it 'initializes with default value if given no arguments' do
      expect(game.towers).to eq([[3, 2, 1], [], []])
    end

    it 'initializes with a different height' do
      expect(TowersOfHanoi.new(5).towers).to eq([[5, 4, 3, 2, 1], [], []])
    end

    it 'raises an error if given an invalid argument' do
      expect { TowersOfHanoi.new(-1) }.to raise_error
      expect { TowersOfHanoi.new(0) }.to raise_error
    end
  end

  describe '#moves' do

    subject(:game) { TowersOfHanoi.new }

    it "should make legal moves" do
      game.move(0,1)
      expect(game.towers).to eq([[3, 2], [1], []])
      game.move(1,0)
      expect(game.towers).to eq([[3, 2,1], [], []])
    end

    it "should raise an error if given illegal moves" do
      expect { game.move(1,0) }.to raise_error("Can't move from an empty pile")
      game.move(0,1)
      expect { game.move(0,1) }.to raise_error("Can't move a larger disc onto a smaller disc")
    end
  end

  describe '#won?' do
    subject(:game) { TowersOfHanoi.new }

    it "shouldn't declare victory immediately" do
      expect(game).to_not be_won
    end

    it "should recognize victory" do
      game.towers = [[],[],[3,2,1]]
      expect(game).to be_won

      game.towers = [[],[3,2,1],[]]
      expect(game).to be_won
    end

    it "should not be won prematurely" do
      game.towers = [[],[2],[3,1]]
      expect(game).to_not be_won
    end
  end

  describe '#render' do

    subject(:game) { TowersOfHanoi.new }

    it "renders the initial board correctly" do
      expect(game.render).to eq("3 2 1 \n\n\n")
    end

    it "renders a winning board correctly" do
      game.towers = [[],[],[3,2,1]]
      expect(game.render).to eq("\n\n3 2 1 \n")
      game.towers = [[], [3, 2, 1], []]
      expect(game.render).to eq("\n3 2 1 \n\n")
    end

    it "renders an intermediate board correctly" do
      game.towers = [[1], [3, 2], [4]]
      expect(game.render).to eq("1 \n3 2 \n4 \n")
    end
  end
end
