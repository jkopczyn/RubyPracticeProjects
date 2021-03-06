require_relative 'piece.rb'

class Pawn < Piece
  DIAGONALS_UP = [[-1,-1], [1,-1]]
  UP = [0,-1]
  UP_TWO = [0,-2]
  DIAGONALS_DOWN = [[-1,1], [1,1]]
  DOWN = [0,1]
  DOWN_TWO = [0,2]

  attr_accessor :has_moved

  def initialize(options)
    super
    @symbol = (color == :black) ? :♟ : :♙
    @has_moved = false
  end

  def moves
    possible_spaces = []
    if @color == :white
      forward_one = stepped_position(UP)
      forward_two = stepped_position(UP_TWO)
    elsif @color == :black
      forward_one = stepped_position(DOWN)
      forward_two = stepped_position(DOWN_TWO)
    else
      raise TypeError.new("We do not support 50 shades of grey")
    end

    possible_spaces += captures

    if !@board.occupied?(forward_one)
      possible_spaces << forward_one
      if !@has_moved && !@board.occupied?(forward_two)
        possible_spaces << forward_two
      end
    end

    possible_spaces.keep_if { |m| @board.in_bounds?(m) }
  end

  def captures
    possible_spaces = []
    if @color == :white
      diagonal_spaces = DIAGONALS_UP.map {|diff| stepped_position(diff) }
    elsif @color == :black
      diagonal_spaces = DIAGONALS_DOWN.map {|diff| stepped_position(diff) }
    else
      raise TypeError.new("We especially do not support 50 shades of grey for captures")
    end
    diagonal_spaces.each do |space|
      if @board.occupied?(space) && @board.whats_here(space).color == ( @color== :white ? :black : :white )
        possible_spaces << space
      end
    end

    possible_spaces
  end

  def stepped_position(step)
    [@position[0]+step[0],
     @position[1]+step[1]]
  end

  def deep_dup
    almost_dup = super
    almost_dup.has_moved = @has_moved

    almost_dup
  end
end
