require 'rspec'
require 'arrays'

describe Array do
  describe "#my_uniq" do
    let(:non_unique) { [1,2,2,3,7,4,1,1,7] }
    let(:unique) { [1,2,3,7,4] }

    it "returns empty array from an empty array" do
      expect([].my_uniq).to eq([])
    end

    it "preserves an array with all unique elements" do
      expect(unique.my_uniq).to eq(unique)
    end

    it "removes repeated elements" do
      expect(unique.my_uniq).to eq(unique)
    end

    it "does not modify original array" do
      old = non_unique.dup
      non_unique.my_uniq
      expect(non_unique).to eq(old)
    end
  end

  describe "#two_sum" do
    let(:test_array1) { [-1, 5, 2, -2, 1] }
    it "returns empty array from an empty array" do
      expect([].two_sum).to eq([])
    end

    it "finds pairs where they exist" do
      expect(test_array1.two_sum).to eq([[0, 4], [2, 3]])
    end

    it "finds multiple pairs with the same number" do
      expect([-1, 1, 2, 1].two_sum).to eq([[0, 1], [0, 3]])
    end

    it "returns ordered pairs sorted" do
      expect(test_array1.reverse.two_sum).to eq([[0, 4], [1, 2]])
    end

    it "treats multiple zeroes as adding to 0" do
      expect([0, 4, 3, -5, 0, 2, 0].two_sum).to eq([[0, 4], [0, 6], [4, 6]])
    end

    it "does not treat a single zero as a pair" do
      expect([4, 0, -4].two_sum).to eq([[0, 2]])
    end

    it "does not modifify original array" do
      old = test_array1.dup
      test_array1.two_sum
      expect(test_array1).to eq(old)
    end
  end

  describe '#my_transpose' do
    let(:basic_array) { [[0, 1], [2, 3]] }

    it "returns empty array from an empty array" do
      expect([].my_transpose).to eq([])
    end

    it "handles a 2x2 case" do
      expect(basic_array.my_transpose).to eq([[0, 2], [1, 3]])
    end

    it "handles a 2x3 array" do
      expect([[0,1,2],[3,4,5]].my_transpose).to eq([[0,3],[1,4],[2,5]])
    end

    it "retains identity of mutable elements" do
      initial_array = [["ab","cd"],["ef","gh"]]
      new_array = initial_array.my_transpose
      expect(initial_array[0][0]).to be new_array[0][0]
      expect(initial_array[0][1]).to be new_array[1][0]
      expect(initial_array[1][0]).to be new_array[0][1]
      expect(initial_array[1][1]).to be new_array[1][1]
    end

    it "does not modifify original array" do
      old = basic_array.dup
      basic_array.my_transpose
      expect(basic_array).to eq(old)
    end
  end

  describe "#stock_picker" do

    let(:simple_week) {[1,2,3,4,5]}

    it "returns nil for empty array" do
      expect([].stock_picker).to be_nil
    end

    it "handles a simple case" do
      expect(simple_week.stock_picker).to eq([0,4])
    end

    it "returns 0,0 for falling market" do
      expect(simple_week.reverse.stock_picker).to eq([0,0])
    end

    it "can't sell before buying" do
      expect([5,1,2,3,4].stock_picker).not_to eq([1,0])
    end

    it "handles a more complex week" do
      expect([1,0,4,2,7,3,-6,0,1].stock_picker).to eq([1,4])
    end
  end

end
