require_relative "board"
require_relative "tile"

class MinesweeperGame
    def initialize(height, width, mines)
        @board = Board.new(height, width, mines)
    end

    def run
        self.play_turn until self.game_over?
        @board.render
        if self.won?
            puts "\nCongrats, you won!"
        else
            puts "\nSorry, you lost."
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

    def play_turn
        @board.render
        move = self.get_move
        pos = self.get_pos
        self.do_move(move, pos)
    end

    def do_move(move, pos)
        if move == "r"
            @board[pos].reveal
        else
            @board[pos].flag
        end
    end

    def get_move
        puts "\nDo you want to reveal a square or flag/unflag a square? (r/f)"
        move = parse_move(gets.chomp)
        until self.valid_move?(move)
            puts "Sorry, not a valid move. Please try again. (r/f)"
            move = parse_move(gets.chomp)
        end
        move
    end

    def valid_move?(move)
        move == "r" || move == "f"
    end

    def parse_move(move)
        move.downcase
    end

    def get_pos
        puts "Enter the coordinates for the square you want to reveal or flag/unflag (e.g. 3,4)."
        pos = parse_pos(gets.chomp)
        until self.valid_pos?(pos)
            puts "Sorry, not valid coordinates. Please try again."
            pos = parse_pos(gets.chomp)
        end
        pos
    end

    def valid_pos?(pos)
        pos && pos[0].between?(0, @board.height - 1) && pos[1].between?(0, @board.width - 1)
    end

    def parse_pos(pos)
        begin
            pos.split(",").map { |char| Integer(char) }
        rescue
            return nil
        end
    end
end

if __FILE__ == $PROGRAM_NAME
    puts "Welcome to minesweeper!"
    diff_level = nil

    until diff_level && ["b","i","h"].include?(diff_level)
        puts "Do you want to play beginner, intermediate, or hard? (b/i/h)"
        diff_level = gets.chomp
    end

    if diff_level == "b"
        height, width, mines = 9, 9, 10
    elsif diff_level == "i"
        height, width, mines = 16, 16, 40
    else
        height, width, mines = 16, 30, 99
    end

    game = MinesweeperGame.new(height, width, mines)
    game.run
end