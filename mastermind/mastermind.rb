class MasterMind
  CODEMAKER = 0
  CODEBREAKER = 1
  CODE_PEGS_COLORS = ["Blank", "Red", "Green", "Blue", "Yellow", "Orange", "Purple"]
  MAX_ATTEMPTS = 12

  attr_accessor :player_name
  attr_reader :player_role, :winner

  def initialize(player_name, player_role, attempts)
    @player_name = player_name
    @player_role = player_role
    self.attempts = attempts
    self.pattern = []
    self.guess = nil
    self.feedback = []
    self.g_count = 0
    self.f_count = 0

    self.guesses = Array.new(attempts, Array.new(4, ""))
    self.feedbacks = Array.new(attempts, Array.new(4, ""))
  end

  def make_pattern
    4.times do
      index = rand(MasterMind::CODE_PEGS_COLORS.length)
      pattern.push(MasterMind::CODE_PEGS_COLORS[index])
    end

    if player_role == MasterMind::CODEMAKER
      pattern
    else
      nil # do not expose pattern to CODEBREAKER
    end
  end

  def display_board
    lwidth = 94

    system("clear")
    puts
    puts "#{'MASTERMIND GAME'.center(lwidth)}"
    puts

    print "#{'GUESSES'.center(37)}"
    print "                    "
    puts "#{'FEEDBACKS'.center(37)}"

    11.downto(0) do |index|
      4.times { |color| print "|#{guesses[index][color].center(8)}" }
      print "|"
      print "                    "
      4.times { |color| print "|#{feedbacks[index][color].center(8)}" }
      puts "|"
    end
  end

  def guess_pattern
    self.guess = []
    input_guess = ""

    loop do
      display_colors
      print "Enter your guess (input numbers corresponding to your guess): "
      input_guess = gets.chomp.split('') # string of indexes

      if valid?(input_guess)
        break
      else
        puts "Try again!"
      end
    end

    input_guess.each do |char|
      index = char.to_i
      guess.push(MasterMind::CODE_PEGS_COLORS[index])
    end

    self.attempts = attempts - 1

    guesses[g_count] = guess
    self.g_count = g_count + 1
    guess
  end

  def give_feedback
    self.feedback = Array.new(4, nil)
    colors_state = []

    pattern.each do |color|
      colors_state.push([color, -1])
    end

    # check for exact matches first
    guess.each_with_index do |color, index|
      if color == pattern[index]
        feedback[index] = "Black"
        colors_state[index][1] = 0
      end
    end

    # now set the whites and blanks ("-")
    feedback.each_with_index do |status, index|
      if status.nil? # meaning, no feedback yet for the guess
        match = colors_state.index([guess[index], -1])
        if match
          feedback[index] = "White"
          colors_state[match][1] = 0
        else
          feedback[index] = "-"
        end
      end
    end

    feedbacks[f_count] = feedback
    self.f_count = f_count + 1
    feedback
  end

  def over?
    if pattern_cracked?
      @winner = MasterMind::CODEBREAKER
      display_board # one last time to show the guess is correct
      true
    elsif attempts == 0
      @winner = MasterMind::CODEMAKER
      true
    else
      false
    end
  end

  def winner
    (@winner == MasterMind::CODEMAKER) ? "COMPUTER" : player_name.upcase
  end

  private
  attr_accessor :pattern, :attempts, :guess, :guesses, :feedback, :feedbacks, :g_count, :f_count

  def pattern_cracked?
    if guess == pattern
      @winner = MasterMind::CODEBREAKER
      true 
    else
      false
    end
  end

  def display_colors
    puts

    MasterMind::CODE_PEGS_COLORS.each_with_index do |color, index|
     print "| #{index} - #{color} "
    end
    puts "|"
  end

  def valid?(input)
    indexes = ["0", "1", "2", "3", "4", "5", "6"]

    if input.length != 4
      puts "Enter only 4 numbers corresponding to your guess pattern."
      return false
    end

    input.each do |i|
      if indexes.index(i).nil?
        puts "Invalid input (#{i}). Enter four numbers only from 0 to 6."
        return false
      end
    end

    true
  end
end


# sample usage
game = MasterMind.new("Lou", MasterMind::CODEBREAKER, MasterMind::MAX_ATTEMPTS)
game.make_pattern

loop do
  game.display_board
  game.guess_pattern
  game.give_feedback

  break if game.over?
end

puts "GAME OVER!"
puts "Winner: #{game.winner}"
