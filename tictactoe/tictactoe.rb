class TicTacToe
  def initialize(player_one, player_two)
    @players = Hash.new()
    @board = []
    @winner = nil

    @player_one = player_one
    @player_two = player_two
    @players = {
      player_one => "O",
      player_two => "X"
    }

    # initialize board
    3.times do
      col = []
      3.times { |i| col.push("-") }

      @board.push(col)
    end
  end

  def play
    i = 0

    display_board

    loop do
      if i.even?
        make_move(@player_one)
      else
        make_move(@player_two)
      end

      display_board
      i += 1
      break if game_over?
    end
  end

  private
  def display_board
    for i in 0..2
      for j in 0..2
        print "|#{@board[i][j]}"
      end
      puts "|"
    end
  end

  def update_board(row, column, mark)
    @board[row][column] = mark
  end

  def make_move(player)
    row, column = 0, 0

    loop do
      puts "Enter move for #{player}: "
      move = gets.chomp.to_i

      # include error handling for player move
      case move
      when 1..3
        row = 0
        column = move - 1  
      when 4..6
        row = 1
        column = move % 4
      when 7..9
        row = 2
        column = move % 7
      else
        # error message/handling here
        # loop user to input choice again?
        puts "Sorry, your move is incorrect. Please try again."
        next
      end

      unless @board[row][column] == "-"
        puts "Oops. That move is already taken. Please try again."
      else
        # accept user move if not yet taken/filled
        break
      end
    end

    update_board(row, column, @players[player])
  end

  def game_over?
    # check horizontal patterns
    for row in 0..2
      unless @board[row][0] == "-"
        if @board[row][0] == @board[row][1] &&
           @board[row][1] == @board[row][2]
          return true
        else
          next
        end
      else
        next
      end
    end

    # check vertical patterns
    for column in 0..2
      unless @board[0][column] == "-"
        if @board[0][column] == @board[1][column] &&
           @board[1][column] == @board[2][column]
          return true
        else
          next
        end
      else
        next
      end
    end

    # check diagonal patterns
      if @board[0][0] != "-"
        if @board[0][0] == @board[1][1] &&
           @board[1][1] == @board[2][2]
          return true
        end
      end

      if @board[2][0] != "-"
        if @board[2][0] == @board[1][1] &&
           @board[1][1] == @board[0][2]
          return true 
        end
      end

    false
  end
end


# sample usage
game = TicTacToe.new("Lou", "Tine")
game.play
