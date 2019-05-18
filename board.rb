require_relative 'tile'

class Board
    def initialize
        @grid = self.populate
    end

    def populate
        grid = Array.new(9) { [] }
        bomb_locs = self.seed_bombs
        (0..8).each do |row_i|
            (0..8).each do |col_i|
                pos = [row_i, col_i]
                bombed = bomb_locs.include?(pos)
                grid[row_i] << Tile.new(pos, bombed, self)
            end
        end
        grid
    end

    def seed_bombs
        bomb_locs = []
        until bomb_locs.length == 10
            pos = [rand(0..8), rand(0..8)]
            bomb_locs << pos unless bomb_locs.include?(pos)
        end
        bomb_locs
    end
end