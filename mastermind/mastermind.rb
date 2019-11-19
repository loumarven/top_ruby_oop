require_relative "common.rb"
require_relative "board.rb"
require_relative "codemaker.rb"
require_relative "codebreaker.rb"

class MasterMind
  include Common

  attr_reader :winner

  def initialize(player_name, player_role, attempts)
    @player_name = player_name
    @player_role = player_role
    @attempts = attempts
    @board = Board.new(attempts)
    @codemaker = nil
    @codebreaker = nil
    
    if player_role == CODEMAKER
      @codemaker = CodeMaker.new(HUMAN)
      @codebreaker = CodeBreaker.new(COMPUTER)
    else
      @codemaker = CodeMaker.new(COMPUTER)
      @codebreaker = CodeBreaker.new(HUMAN)
    end
  end

  def play
    @codemaker.make_pattern
    guess = nil
    feedback = nil

    loop do
      @board.display

      guess = @codebreaker.guess_pattern(feedback)
      @board.put(guess, CODEBREAKER)

      feedback = @codemaker.give_feedback(guess)
      @board.put(feedback, CODEMAKER)

      if over?
        @board.display
        break
      else
        @attempts = @attempts - 1
      end
    end
  end

  private
  def over?
    if @codebreaker.guess == @codemaker.pattern
      @winner = (@player_role == CODEBREAKER) ? @player_name : COMPUTER
      true
    elsif @attempts == 0
      @winner = (@player_role == CODEMAKER) ? @player_name : COMPUTER
      true
    else
      false
    end
  end
end
