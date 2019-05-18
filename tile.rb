require_relative "board"

class Tile
    attr_reader :bombed
    attr_accessor :flagged, :revealed

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
        x, y = @pos
        (x-1..x+1).each do |x_neighbor|
            next if !x_neighbor.between?(0, 8)
            (y-1..y+1).each do |y_neighbor|
                next if !y_neighbor.between?(0, 8)
                pos_neighbor = [x_neighbor, y_neighbor]
                neighbors << pos_neighbor unless @pos == pos_neighbor
            end
        end
        neighbors
    end

    def neighbor_bomb_count
        self.neighbors.count { |neighbor_pos| @board[neighbor_pos].bombed }
    end

    def inspect
        { pos: @pos, bombed: @bombed, flagged: @flagged, revealed: @revealed }
    end

    def to_s
        if @flagged
            return "F"
        elsif !@revealed
            return "*"
        end
    end
end