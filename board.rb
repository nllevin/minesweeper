require_relative 'tile'

class Board
    attr_reader :grid, :height, :width, :mines

    def initialize(height, width, mines)
        @height = height
        @width = width
        @mines = mines
        @grid = self.populate
    end

    def populate
        grid = Array.new(@height) { [] }
        bomb_locs = self.seed_bombs
        grid.each_with_index do |row, row_i|
            (0...@width).each do |col_i|
                pos = [row_i, col_i]
                bombed = bomb_locs.include?(pos)
                row << Tile.new(pos, bombed, self)
            end
        end
        grid
    end

    def seed_bombs
        bomb_locs = []
        until bomb_locs.length == @mines
            pos = [rand(0...@height), rand(0...@width)]
            bomb_locs << pos unless bomb_locs.include?(pos)
        end
        bomb_locs
    end

    def render
        system("clear")
        puts "  " + (0...@width).to_a.join(" ")
        puts "  " + "-" * (@width * 2 - 1)
        @grid.each_with_index { |row, row_i| puts "#{row_i}|#{row.map(&:to_s).join(" ")}" }
        puts "Unflagged bombs remaining: #{self.bombs_left}"
    end

    def bombs_left
        @mines - @grid.inject(0) { |num, row| num += row.count { |tile| tile.flagged } }
    end

    def [](pos)
        x, y = pos
        @grid[x][y]
    end
end