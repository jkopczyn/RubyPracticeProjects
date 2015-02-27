class TowersOfHanoi
  attr_accessor :towers

  def initialize(n=3)
    raise ArgumentError.new if n < 1
    @towers = [(1..n).to_a.reverse,[],[]]
  end

  def move(from,to)
    raise "Can't move from an empty pile" if towers[from].empty?
    if can_move_to(towers[from].last, towers[to])
      towers[to] << towers[from].pop
    else
      raise "Can't move a larger disc onto a smaller disc"
    end
  end

  def can_move_to(disc, tower)
    tower.empty? || disc <= tower.last
  end

  def won?
    towers[0].empty? && (towers[1].empty? || towers[2].empty?)
  end

  def render
    accum = ""
    towers.each do |tower|
      tower.each do |disc|
        accum << "#{disc} "
      end
      accum << "\n"
    end
    accum
  end
end
