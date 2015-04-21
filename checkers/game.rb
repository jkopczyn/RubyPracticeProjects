require_relative './board.rb'
require_relative './player.rb'

class Game
    attr_accessor :board, :players, :current_player
    
    def initialize(options = {})
        @board = options[:board] || Board.new
        @players = options[:players] || {black: Player.new, 
                                         red: Player.new}
        @current_player = black_player
    end

    def black_player
        players[:black]
    end

    def red_player
        players[:red]
    end

    def play
    begin
        self.current_player = black_player
        loop do
            puts "#{current_color.capitalize}'s turn"
            make_move(current_player.prompt_for_move(board))
            switch_player
            break if winner
        end
        self.current_player = winner
        puts "#{current_color.capitalize} wins!"
    rescue RuntimeError => e
       puts e.message
       retry
    rescue Interrupt
        if winner
            puts "#{current_color.capitalize} wins!"
        else
            puts "It's a tie"
        end
    end
    end

    def make_move(posn_list)
        if posn_list.empty?
            raise "You still have moves available"
        elsif board[*(posn_list.first)].color != current_color
            raise "That's not your piece"
        end
        board.move(posn_list.first, posn_list.drop(1))
    end
        

    def switch_player
        if current_player    == black_player
            self.current_player = red_player
        elsif current_player == red_player
            self.current_player = black_player
        else
            raise "Invalid Player"
        end
        #current_player = opposite_player
    end

    def winner
        if player_loses?(current_player)
            return opposite_player
        elsif player_loses?(opposite_player)
            return current_player
        else
            nil
        end
    end

    def player_loses?(player)
        board.find_pieces(current_color).empty? || 
            board.find_pieces(current_color).map(&:jumps).inject(&:+).empty?
    end


    def opposite_color
        if current_player    == black_player
            :red
        elsif current_player == red_player
            :black
        else
            raise "Invalid Player"
        end
    end

    def current_color
        if current_player    == black_player
            :black
        elsif current_player == red_player
            :red
        else
            raise "Invalid Player"
        end
    end

    def opposite_player
        players[opposite_color]
    end
end


if __FILE__ == $PROGRAM_NAME
    g= Game.new
    g.play
end

