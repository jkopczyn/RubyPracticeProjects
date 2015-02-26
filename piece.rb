class Piece
    attr_reader :color, :posn

    UP_SLIDES = [[-1,-1], [1,-1]]
    DOWN_SLIDES = [[-1,1], [1,1]]
    BLACK_SLIDES = UP_SLIDES
    RED_SLIDES = DOWN_SLIDES

    UP_JUMPS = UP_SLIDES.ma {|x,y| [2*x,2*y]}
    DOWN_JUMPS = DOWN_SLIDES.map {|x,y| [2*x,2*y]}
    BLACK_JUMPS = UP_JUMPS
    RED_JUMPS = DOWN_JUMPS

    def initialize(options = {})
        @king = options[:king] || false
        @posn = options[:posn]
        @color = options[:color]
        @board = options[:board]
    end
    
    def king?
        @king
    end

    def slides
        raw_slides.filter { |square| board.empty?(square) }
    end
 
    def jumps
        raw_slides.each_with_object([]) do |middle_square, jumps| 
            if board.empty?(middle_square)
                next
            elsif !board.empty?(double_move(middle_square))
                next
            else
                jumps << double_move(middle_square)
            end
        end
    end

    private
    def raw_slides
        cands = UP_SLIDES + DOWN_SLIDES if king?
        case color
        when :black
            cands = BLACK_SLIDES
        when :red
            cands = RED_SLIDES
        else
            raise "Piece has invalid color"
        end

        cands.map { |diff| [posn[0] + diff[0], posn[1] + diff[1]] }
    end

    def double_move(diff_posn)
        x,y = diff_posn

        [2*x,2*y]
    end

    def set_posn!(value)
        @posn = value
    end
end
