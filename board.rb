require_relative 'tile'

class Board
    attr_reader :grid, :height, :width, :mines
    attr_accessor :active_pos

    def initialize(height, width, mines)
        @height = height
        @width = width
        @mines = mines
        @active_pos = [0, 0]
        @grid = self.populate
    end

    def populate
        grid = Array.new(@height) { [] }
        grid.each_with_index do |row, row_i|
            (0...@width).each { |col_i| row << Tile.new([row_i, col_i], self) }
        end
        grid
    end

    def seed_bombs!(first_pos)
        bomb_locs = []
        first_tile = self[first_pos]
        first_neighbors = first_tile.neighbors
        until bomb_locs.length == @mines
            bomb_pos = [rand(0...@height), rand(0...@width)]
            unless bomb_locs.include?(bomb_pos) || 
                        bomb_pos == first_pos || 
                        first_neighbors.any? { |neighbor| neighbor.pos == bomb_pos }
                bomb_locs << bomb_pos
                self[bomb_pos].bombed = true
            end
        end
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