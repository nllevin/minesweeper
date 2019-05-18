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
        if !@bombed && self.neighbor_bomb_count == 0
            self.neighbors.each { |neighbor_pos| @board[neighbor_pos].reveal }
        end
    end

    def flag
        @flagged = !@flagged
    end

    def neighbors
        neighbors = []
        x, y = @pos
        (x-1..x+1).each do |x_neighbor|
            next if !x_neighbor.between?(0, 8)
            (y-1..y+1).each do |y_neighbor|
                next if !y_neighbor.between?(0, 8)
                pos_neighbor = [x_neighbor, y_neighbor]
                neighbors << pos_neighbor unless @pos == pos_neighbor || @board[pos_neighbor].revealed
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
        if !@revealed && @flagged
            return "F"
        elsif !@revealed
            return "*"
        elsif @bombed
            return "B"
        elsif self.neighbor_bomb_count > 0
            return "#{self.neighbor_bomb_count}"
        else
            return "_"
        end
    end
end