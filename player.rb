class Player

    def initialize(options = {}) ; end

    def prompt_for_move(board)
        board.display
        posn_list = []
        puts "Select a piece to move (enter coordinates x,y)"
        posn_list << gets.split(',').map(&:to_i)
        loop do
            puts "Enter another x,y to move the piece there"
            puts "Or end your turn with anything else"
            next_posn = gets.split(',').map(&:to_i)
            unless next_posn.is_a?(Array) && next_posn.count == 2
                break
            else
                posn_list << next_posn
            end
        end

        posn_list
    end

end
