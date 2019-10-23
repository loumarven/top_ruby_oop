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
    system("clear")

    lwidth = 78
    puts "#{'MASTERMIND GAME'.center(lwidth)}"
    puts

    puts "#{'GUESSES'.center(29)}"\
          "#{'FEEDBACKS'.rjust(39)}"
    puts

    11.downto(0) do |index|
      4.times { |color| print "|#{guesses[index][color].center(6)}" }
      print "|"
      print "                    "
      4.times { |color| print "|#{feedbacks[index][color].center(6)}" }
      puts "|"
    end
  end

  def guess_pattern
    self.guess = []
    input_guess = ""

    puts
    display_colors

    loop do
      print "Enter your guess (input numbers corresponding to your guess): "
      input_guess = gets.chomp.split('') # string of indexes

      if input_guess.length != 4
        puts "Error! Guess 4 colors only."
        puts "Try again!"
        next
      else
        break
      end
    end

    # TODO: accept integers between 0 and 6 only
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
      puts "PATTERN: #{pattern}"
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
    MasterMind::CODE_PEGS_COLORS.each_with_index do |color, index|
     print "| #{index} - #{color} "
    end
    puts "|"
  end
end


# sample usage
game = MasterMind.new("Lou", MasterMind::CODEBREAKER, MasterMind::MAX_ATTEMPTS)
puts game.make_pattern

until game.over?
  game.display_board
  game.guess_pattern
  game.give_feedback
end

puts "GAME OVER!"
puts "Winner: #{game.winner}"
