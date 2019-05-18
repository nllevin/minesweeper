require_relative "board"

class Tile
    attr_reader :bombed

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

    def inspect
        { pos: @pos, bombed: @bombed, flagged: @flagged, revealed: @revealed }
    end

    def to_s
        if !@revealed
            return "*"
        end
    end
end