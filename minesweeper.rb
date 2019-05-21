require_relative "board"
require_relative "tile"
require "yaml"
require "io/console"

class MinesweeperGame
    def initialize(height, width, mines)
        @board = Board.new(height, width, mines)
    end

    def run
        self.play_first_turn
        self.play_turn until self.game_over?
        self.display_outcome
    end

    def display_outcome
        if self.won?
            @board.grid.flatten.each { |tile| tile.flag if tile.bombed }
            @board.render
            puts "\nCongrats, you won!"
        else
            @board.grid.flatten.each { |tile| tile.reveal if tile.bombed }
            @board.render
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

    def play_first_turn
        @board.render
        input = self.read_char
        until input == "r"
            self.execute_cursor_input(input)
            @board.render
            input = self.read_char
        end
        @board.seed_bombs!(@board.active_pos)
        self.alter_tile("r")
    end

    def execute_cursor_input(input)
        if self.valid_tile_alteration?(input)
            self.alter_tile(input)
        elsif self.valid_cursor_movement?(input)
            self.move_cursor(input)
        end
    end

    def play_turn
        @board.render
        input = self.read_char
        self.execute_cursor_input(input)
    end

    def alter_tile(action)
        active_pos = @board.active_pos
        self.save_game if action == "s"
        if action == "r"
            @board[active_pos].reveal
        else
            @board[active_pos].flag
        end
        exit if action == "\e"
    end

    def save_game
        puts "How would you like to name your saved game?"
        save_name = gets.chomp
        File.open(save_name, "w") { |file| file.write(self.to_yaml) }
        puts "Game saved!"
        exit
    end

    def valid_tile_alteration?(input)
        input = input.downcase
        input == "r" || input == "f" || input == "s" || input == "\e"
    end

    def valid_cursor_movement?(input)
        input == "\e[A" || input == "\e[B" || input == "\e[C" || input == "\e[D"
    end

    def move_cursor(input)
        x, y = @board.active_pos
        case input
        when "\e[A"                                                 #up
            @board.active_pos = [x-1,y] unless x == 0
        when "\e[B"                                                 #down
            @board.active_pos = [x+1,y] unless x == @board.height - 1
        when "\e[C"                                                 #right
            @board.active_pos = [x,y+1] unless y == @board.width - 1
        when "\e[D"                                                 #left
            @board.active_pos = [x,y-1] unless y == 0
        end
    end

    def read_char
        STDIN.echo = false
        STDIN.raw!

        input = STDIN.getc.chr
        if input == "\e" then
            input << STDIN.read_nonblock(3) rescue nil
            input << STDIN.read_nonblock(2) rescue nil
        end
        ensure
        STDIN.echo = true
        STDIN.cooked!

        return input
    end
end

if __FILE__ == $PROGRAM_NAME
    def load_game
        puts "Please enter the name of your saved game file."
        file_name = gets.chomp
        begin
            game = YAML.load(File.read(file_name))
        rescue
            puts "Sorry, not a valid file name."
            game = load_game
        end
        game
    end

    def select_difficulty_level
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

        MinesweeperGame.new(height, width, mines)
    end

    puts "Welcome to minesweeper!"

    input = nil
    until input && input == "y" || input == "n"
        puts "Would you like to load a saved game? (y/n)"
        input = gets.chomp
    end

    if input == "n"
        game = select_difficulty_level
    else
        game = load_game
    end

    game.run
end