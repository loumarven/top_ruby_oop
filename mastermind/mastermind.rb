class MasterMind
  CODEMAKER = 0
  CODEBREAKER = 1
  MAX_ATTEMPTS = 12

  attr_accessor :player_name, :attempts
  attr_reader :player_role, :winner

  def initialize(player_name, player_role, attempts)
    @player_name = player_name
    @player_role = player_role
    @attempts = attempts
  end

  def make_pattern
    puts "Made a pattern!"
    self.pattern = 1
    pattern
  end

  def guess_pattern
    puts
    puts "Enter your guess: "
    self.guess = gets.chomp.to_i

    self.attempts = self.attempts - 1
    guess
  end

  def give_feedback
    #TODO: algorithm
  end

  def over?
    # pattern_cracked? || attempts == 0
    if pattern_cracked?
      @winner = MasterMind::CODEBREAKER
      true
    elsif attempts == 0
      @winner = MasterMind::CODEMAKER
      true
    else
      puts "Remaining attempts: #{attempts}"

      false
    end
  end

  def winner
    (@winner == MasterMind::CODEMAKER) ? "COMPUTER" : player_name.upcase
  end

  private
  attr_accessor :pattern, :guess

  def pattern_cracked?
    if guess == pattern
      @winner = CODEBREAKER
      true 
    else
      false
    end
  end
end


# sample usage
game = MasterMind.new("Lou", MasterMind::CODEBREAKER, MasterMind::MAX_ATTEMPTS)
pattern = game.make_pattern

until game.over?
  if game.guess_pattern != pattern
    game.give_feedback
  end
end

puts "Winner: #{game.winner}"
