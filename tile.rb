class Tile
    def initialize(pos, board)
        @pos = pos
        @board = board
        @bombed = board[pos].bomb?
        @flagged = false
        @revealed = false
    end
end