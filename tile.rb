require_relative "board"

class Tile
    def initialize(pos, bombed, board)
        @pos = pos
        @board = board
        @bombed = bombed
        @flagged = false
        @revealed = false
    end

    def reveal
        @revealed = true
    end

    def neighbors
        neighbors = []
        # finish neighbors
    end

    def neighbor_bomb_count
        #finish
    end
end