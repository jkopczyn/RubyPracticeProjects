require_relative "./piece.rb"
require 'byebug'
require 'colorize'

class Board
    attr_accessor :grid
    
    def initialize(options = {})
        @grid ||= options[:grid]
        initial_grid if @grid.nil?
    end

    def inspect 
        string = "["
        @grid.each do |row|
            string << "["
            row.each do |cell|
                if cell.is_a?(Piece)
                    king_str = cell.king? ? 'true' : 'false'
                    next_bit = "<Piece #{cell.color} K?#{king_str}>, "
                    string << next_bit
                else
                    string << "n, "
                end
            end
            string << "]\n"
        end
        string << "]"
        string
    end

    def empty?(posn)
        self[*posn].nil?
    end

    def occupied?(posn)
        !empty?(posn)
    end

    def [](x,y)
        grid[y][x]
    end

    def []=(x,y, value)
        grid[y][x] = value
    end

    def set_posn(piece,posn)
        raise "Piece missing" unless self[*piece.posn] == piece
        set_posn!(piece,posn,piece.posn)
    end

    
    def set_posn!(piece, posn, old_posn)
        self[*posn] = piece
        piece.set_posn!(posn)
        self[*old_posn] = nil
    end

    def display
        puts render
    end

    def render
        out_string = ""
        grid.each_with_index do |row,vertical_index|
            row.each_with_index do |space,horizontal_index|
                posn = [horizontal_index,vertical_index]
                if space.nil?
                    space_string = "  "
                elsif space.is_a?(Piece)
                    space_string = space.symbol.colorize(space.color)
                else
                    raise "Invalid object at #{posn} should be a Piece"
                end
                bgcolor = {:background => background_color(posn)}
                out_string << space_string.colorize(bgcolor)
            end
            out_string << "\n"
        end

        out_string
    end

    def background_color(posn)
        if posn.inject(&:+)%2 == 0
            :blue
        else
            :white
        end
    end

    def move(start_posn, target_posns)
        raise "Invalid Move, no piece there" if empty?(start_posn)
        piece = self[*start_posn]
       
        if target_posns.count == 2 && target_posns.first.class != Array
            make_one_move(piece,start_posn,target_posns)
        else
           make_some_jumps(piece, start_posn, target_posns) 
        end

        maybe_promote(piece)
    end

    def maybe_promote(piece)
        

        piece
    end

    private
    def check_one_move(from_posn, to_posn, piece)
        #returns :slide, :jump, or false
        ghost = make_test_piece(piece.color, piece.king?,from_posn)
        if ghost.jumps.include?(to_posn)
            return :jump
        elsif ghost.slides.include?(to_posn)
            return :slide
        else
            return false
        end
    end

    def make_one_move(piece, start_posn, end_posn)
    move_type = check_one_move(start_posn, end_posn, piece)
            if :slide == move_type
                set_posn(piece, end_posn)
            elsif :jump == move_type
                self[*jumped_over(start_posn, end_posn)] = nil
                set_posn(piece, end_posn)
            else
                raise "Invalid Move, piece cannot move there" 
            end
    end

    def make_some_jumps(piece, start_posn,target_posns)
        captures = []
        from_posn = start_posn

        target_posns.each do |to_posn|
            move_type = check_one_move(from_posn, to_posn, piece)
            case move_type
            when :jump
                captures << jumped_over(from_posn, to_posn)
                from_posn = to_posn    
            when :slide
                raise "Invalid Move, piece cannot slide after jump"
            else                       
                raise "Invalid Move, piece cannot move there" 
            end                        
        end
        #final from_posn is destination square
        set_posn(piece,from_posn)
        captures.each do |captured_posn|
            self[*captured_posn] = nil
        end

    end

    def jumped_over(start_posn,end_posn)
        Board.midpoint(start_posn,end_posn)
    end

    def self.midpoint(start_posn,end_posn)
        [(start_posn[0]+end_posn[0])/2, 
         (start_posn[1]+end_posn[1])/2] 
    end

    RED_SIDE = (0..2).to_a
    BLACK_SIDE =  (5..7).to_a

    def initial_grid
        self.grid = Array.new(8) { Array.new(8) }
        self.grid.each_with_index do |row, index|
            row.each_index do |col|
                if 1 == (index + col)%2
                    next
                elsif RED_SIDE.include?(index)
                    make_piece(row,:red,[col,index])
                elsif BLACK_SIDE.include?(index)
                    make_piece(row,:black,[col,index])
                else
                    next
                end
            end
        end
    end

    def make_piece(row, color,posn)
        p =  Piece.new({color: color, board: self})
        p.set_posn!(posn)
        row[posn[0]] = p
    end

    def make_test_piece(color,king,posn)
        #makes a piece the board does not store
        p = Piece.new({color: color, board: self, king: king})
        p.set_posn!(posn)
        p
    end
end

def setup_jump
    b = Board.new
    #b.display
    #puts "\n"
    b.move([0,2],[1,3])
    b.move([3,5],[2,4])
    b.move([5,5],[6,4])
    b.move([6,4],[7,3])
    b.move([7,5],[6,4])
    b.move([6,6],[5,5])
    b.move([5,7],[6,6])
    b.display
    puts "\n"
    #puts "a jump; b.move([1,3],[3,5])"

    b
end


