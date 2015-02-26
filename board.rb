class Board
    attr_accessor :grid
    
    def initialize(options = {})
        @grid ||= options[:grid]
        initial_grid if @grid.nil?
    end

    def empty?(posn)
        self[posn].nil?
    end

    def occupied?(posn)
        !empty?(posn)
    end

    def [](posn)
        grid[posn[1]][posn[0]]
    end

    def []=(posn, value)
        grid[posn[1]][posn[0]] = value
    end

    def set_posn!(piece, posn)
        self[posn] = piece
        piece.set_posn!(posn)
    end

    def move(start_posn, end_posn)
        captures = []
        raise "Invalid Move, no piece there" if 
                empty?(start_posn)
        piece = self[start_posn]
        if piece.jumps.include?(end_posn)
            captures << jumped_over(start_posn,end_posn)
            set_posn!(piece,end_posn)
        elsif piece.slides.include?(end_posn)
            set_posn!(piece,end_posn)
        else
            raise "Invalid Move, piece cannot move there" 
        end
        captures.each do |captured_posn|
            self[captured_posn] = nil
        end

        piece
    end

    private
    def jumped_over(start_posn,end_posn)
        valid_jump? = 
        [].tap |diffs| do
            2.times do |index|
                diffs << (end_posn[index] - start_posn[index])
            end
        end.all? {|val| [-2,2].include?(val) }
        if valid_jump?
            midpoint(start_posn,end_posn)
        else
            nil
        end
    end

    def midpoint(start_posn,end_posn)
        [(start_posn[0]+end_posn[0])/2, 
         (start_posn[1]+end_posn[1])/2] 
    end

    RED_SIDE = (0..2).to_a
    BLACK_SIDE =  (6..8).to_a

    def initial_grid
        @grid = Array.new(8) { Array.new(8) }
        grid.each_with_index do |row, index|
            row.each_index do |col|
                if 1 == (index + col)%2
                    next
                elsif RED_SIDE.include?(index)
                    Piece.new(
                        {color: :red, 
                         board: self}).set_posn!([col,index])
                elsif BLACK_SIDE.include?(index)
                    Piece.new(
                        {color: :black,  
                         board: self}).set_posn!([col,index])
                else
                    next
                end
            end
        end
    end
end
