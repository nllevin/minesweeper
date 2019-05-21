require_relative "board"
require "colorize"

class Tile
    attr_accessor :pos, :bombed, :flagged, :revealed

    def initialize(pos, board)
        @pos = pos
        @board = board
        @bombed = false
        @flagged = false
        @revealed = false
    end

    def reveal
        if !@flagged
            @revealed = true
            if !@bombed && self.neighbor_bomb_count == 0
                self.neighbors.each { |neighbor| neighbor.reveal }
            end
        end
    end

    def flag
        @flagged = !@flagged unless @revealed
    end

    def neighbors
        neighbors = []
        x, y = @pos
        (x-1..x+1).each do |x_neighbor|
            next if !x_neighbor.between?(0, @board.height - 1)
            (y-1..y+1).each do |y_neighbor|
                next if !y_neighbor.between?(0, @board.width - 1)
                neighbor = @board[[x_neighbor, y_neighbor]]
                neighbors << neighbor unless self == neighbor || (neighbor.revealed && !neighbor.bombed)
            end
        end
        neighbors
    end

    def neighbor_bomb_count
        self.neighbors.count { |neighbor| neighbor.bombed }
    end

    def inspect
        { pos: @pos, bombed: @bombed, flagged: @flagged, revealed: @revealed }
    end

    def to_s
        if !@revealed && @flagged
            return "F".colorize(:yellow)
        elsif !@revealed
            return "*"
        elsif @bombed
            return "B"
        else 
            num_bombs = self.neighbor_bomb_count
            return "_" if num_bombs == 0
            return 1.to_s.colorize(:cyan) if num_bombs == 1
            return 2.to_s.colorize(:green) if num_bombs == 2
            return 3.to_s.colorize(:red) if num_bombs == 3
            return 4.to_s.colorize(:blue) if num_bombs == 4
            return 5.to_s.colorize(:light_red) if num_bombs == 5
            return 6.to_s.colorize(:light_green) if num_bombs == 6
            return 7.to_s.colorize(:black) if num_bombs == 7
            return 8.to_s.colorize(:light_black) if num_bombs == 8
        end
    end
end