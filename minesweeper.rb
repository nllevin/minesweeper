require_relative "board"
require_relative "tile"

class MinesweeperGame
    def initialize
        @board = Board.new
    end

    def run
        self.play_turn until self.game_over?
        self.render
        if self.won?
            puts "Congrats, you won!"
        else
            puts "Sorry, you lost."
        end
    end

    def game_over?
        self.won? || self.lost?
    end

    def won?
        @board.grid.all? do |row|
            row.all? { |tile| tile.bombed || tile.revealed }
        end
    end

    def lost?
        @board.grid.any? do |row|
            row.any? { |tile| tile.bombed && tile.revealed }
        end
    end
end

if __FILE__ == $PROGRAM_NAME
    game = MinesweeperGame.new
    game.run
end