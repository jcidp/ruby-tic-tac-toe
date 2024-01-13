# frozen_string_literal: true

# Boards contains the 3x3 grid of the game and the methods to show and edit it
class Board
  attr_reader :board

  def reset_board
    self.board = Array.new(3) { Array.new(3) }
  end

  def show_board
    board.each_with_index do |line, i|
      puts(line.each_with_index.reduce("") do |str, (value, j)|
        str += !value ? "   " : " #{value} "
        str += "|" if j < 2
        str
      end)
      puts "---|---|---" if i < 2
    end
  end

  def place_marker(marker, row, col)
    return false if board.dig(row, col) || !row.between?(0, 2) || !col.between?(0, 2)

    board[row][col] = marker
    true
  end

  private

  attr_writer :board

  def initialize
    reset_board
  end
end
