# frozen_string_literal: true

require "./player"
require "./board"

# A Game handles all the logic to play Tic Tac Toe
class Game
  def setup_game
    puts "Player 1:"
    player1 = ask_player_data
    puts "Player 2:"
    player2 = ask_player_data(player1.name, player1.marker)
    self.players = [player1, player2]
    self.current_player_index = 0
    self.board = Board.new
    play_game
  end

  private

  attr_accessor :board, :players, :current_player_index

  def play_game
    player_wins = nil
    while player_wins.nil?
      play_turn
      board.show_board
      player_wins = check_winner
      change_current_player if player_wins.nil?
    end
    puts "Game over" # For testing
    puts player_wins ? "#{current_player.name} won the game!" : "It's a tie!"
    end_menu
  end

  def play_turn
    valid_move = false
    puts "#{current_player.name} to play"
    until valid_move
      move = ask_move
      valid_move = board.place_marker(current_player.marker, move[0], move[1])
      puts "Position already taken" unless valid_move
    end
  end

  def ask_move
    row = 0
    col = 0
    until row.between?(1, 3)
      puts "What row do you want to play? (Values between 1 and 3)"
      row = gets.chomp.to_i
      puts "Invalid row" unless row.between?(1, 3)
    end
    until col.between?(1, 3)
      puts "What column do you want to play? (Values between 1 and 3)"
      col = gets.chomp.to_i
      puts "Invalid column" unless col.between?(1, 3)
    end
    [row - 1, col - 1]
  end

  def check_winner
    board = self.board.board
    marker = current_player.marker
    return true if check_lines_for_winner(board, marker) || check_diagonals_for_winner(board, marker)
    return false if board.flatten.none?(&:nil?) # Checks the board is full, meaning a tie

    nil
  end

  def check_lines_for_winner(board, marker)
    board.any? { |row| row.all? { |e| e == marker } } ||
      3.times.any? { |col| board.dig(0, col) == marker && board.dig(1, col) == marker && board.dig(2, col) == marker }
  end

  def check_diagonals_for_winner(board, marker)
    (board.dig(0, 0) == marker && board.dig(1, 1) == marker && board.dig(2, 2) == marker) ||
      (board.dig(0, 2) == marker && board.dig(1, 1) == marker && board.dig(2, 0) == marker)
  end

  def play_rematch
    board.reset_board
    change_current_player
    play_game
  end

  def current_player
    players[current_player_index]
  end

  def change_current_player
    self.current_player_index = current_player_index.zero? ? 1 : 0
  end

  def end_menu
    input = ""
    until %w[r n q].include? input
      puts "Enter 'r' to play a rematch, 'n' to setup a game with new players and markers, 'q' to quit."
      input = gets.chomp
      case input
      when "r" then play_rematch
      when "n" then setup_game
      end
      puts "Invalid choice" unless %w[r n q].include? input
    end
  end

  def ask_player_data(taken_name = nil, taken_marker = nil)
    name = ""
    marker = ""
    until name != "" && name != taken_name
      puts "What's your name?"
      name = gets.chomp
    end
    marker = taken_marker == "x" ? "o" : "x" if taken_marker
    until %w[x o].include?(marker) && marker != taken_marker
      puts "Do you want to use the 'x' or the 'o' marker?"
      marker = gets.chomp
    end
    Player.new(name, marker)
  end
end

game = Game.new
game.setup_game
