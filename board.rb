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
        cols = (0...@width).to_a.map do |col|
            if col < 10
                [" ", col]
            else
                col.to_s.split("")
            end
        end
        cols = cols.transpose
        puts "   " + cols[0].join(" ")
        puts "   " + cols[1].join(" ")
        puts "   " + "-" * (@width * 2 - 1)
        @grid.each_with_index do |row, row_i|
            if row_i < 10
                puts "#{row_i} |#{row.map(&:to_s).join(" ")}"
            else
                puts "#{row_i}|#{row.map(&:to_s).join(" ")}"
            end
        end
        puts "Unflagged bombs remaining: #{self.bombs_left}"
        puts "Enter 'save' at any time to save your game."
    end

    def bombs_left
        @mines - @grid.inject(0) { |num, row| num += row.count { |tile| tile.flagged } }
    end

    def [](pos)
        x, y = pos
        @grid[x][y]
    end
end