require_relative "board"

class Tile
    def initialize(pos, board)
        @pos = pos
        @board = board
        @bombed = board[pos].bomb?
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