class Piece
    attr_reader :color, :posn, :board

    UP_SLIDES = [[-1,-1], [1,-1]]
    DOWN_SLIDES = [[-1,1], [1,1]]
    BLACK_SLIDES = UP_SLIDES
    RED_SLIDES = DOWN_SLIDES

    UP_JUMPS = UP_SLIDES.map {|x,y| [2*x,2*y]}
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
    
    def symbol
        sym = ""
        if color == :red
            sym += "@"
        elsif color == :black
            sym += "*"
        else
            raise "Invalid piece color"
        end
        if king?
            sym += "K"
        else
            sym += " "
        end
        
        sym
    end
            

    def inspect
        "<Piece @king=#{king?} @posn=#{posn.inspect} @color=#{color} "\
        "@board = #{@board.nil? ? nil : '<Board ...>'}>"
    end

    def slides
        raw_slides.keep_if { |square| board.empty?(square) }
    end
 
    def jumps
        raw_jumps.each_with_object([]) do |target_square, jumps| 
            if board.empty?(Board.midpoint(posn,target_square))
                next
            elsif !(board.empty?(target_square))
                next
            else
                jumps << target_square
            end
        end
    end

    def set_posn!(value)
        @posn = value
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

     def raw_jumps
        cands = UP_JUMPS + DOWN_JUMPS if king?
        case color
        when :black
            cands = BLACK_JUMPS
        when :red
            cands = RED_JUMPS
        else
            raise "Piece has invalid color"
        end

        cands.map { |diff| [posn[0] + diff[0], posn[1] + diff[1]] }
    end   

    def double_move(diff_posn)
        x,y = diff_posn

        [2*x,2*y]
    end

end
