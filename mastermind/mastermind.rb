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
    @feedback = []
    @feedbacks = []
  end

  def make_pattern
    4.times do
      index = rand(MasterMind::CODE_PEGS_COLORS.length)
      pattern.push(MasterMind::CODE_PEGS_COLORS[index])
    end

    if player_role == MasterMind::CODEMAKER
      pattern
    else
      puts "PATTERN: #{pattern}" # debug
      nil # do not expose pattern to CODEBREAKER
    end
  end

  def guess_pattern
    self.guess = []

    puts
    display_colors

    # TODO: loop guess input until all inputs are valid and within range
    print "Enter your guess (input numbers corresponding to your guess): "
    tmp_guess = gets.chomp.split('') # string of indexes

    tmp_guess.each do |char|
      index = char.to_i
      guess.push(MasterMind::CODE_PEGS_COLORS[index])
    end

    self.attempts = attempts - 1
    guess
  end

  def give_feedback
    #TODO: test/check algorithm
    self.feedback = []

    guess.each_with_index do |color, index|
      if color == pattern[index]
        feedback.push("Black")
      else
        position = pattern.index(color)

        if position.nil? || # guess color not in pattern
           guess.count(color) > pattern.count(color) # guessed the same color more than the actual times it is in the pattern
          feedback.push("Blank")
        else # correct color, wrong position
          feedback.push("White")
        end
      end
    end

    feedbacks.push(feedback)
    feedback
  end

  def over?
    if pattern_cracked?
      @winner = MasterMind::CODEBREAKER
      puts "PATTERN: #{pattern}"
      true
    elsif attempts == 0
      @winner = MasterMind::CODEMAKER
      puts "PATTERN: #{pattern}"
      true
    else
      puts
      puts "Remaining attempts: #{attempts}"
      false
    end
  end

  def winner
    (@winner == MasterMind::CODEMAKER) ? "COMPUTER" : player_name.upcase
  end

  private
  attr_accessor :pattern, :attempts, :guess, :feedback, :feedbacks

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
  print game.guess_pattern
  puts
  puts "--"
  print game.give_feedback
  puts
end

puts
puts "GAME OVER!"
puts "Winner: #{game.winner}"
