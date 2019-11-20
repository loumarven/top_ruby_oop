require_relative "common.rb"
require_relative "board.rb"
require_relative "codemaker.rb"
require_relative "codebreaker.rb"

class MasterMind
  include Common

  attr_reader :winner

  def initialize(player_name)
    @player_name = player_name
    @player_role = CODEBREAKER # default role
    @attempts = MAX_ATTEMPTS
    @board = Board.new(@attempts)
    @codebreaker = CodeBreaker.new(HUMAN)
    @codemaker = CodeMaker.new(COMPUTER)
  end

  # TODO: create prompt for user role selection
  def player_role=(role)
    @player_role = role

    if role == CODEMAKER
      @codemaker = CodeMaker.new(HUMAN)
      @codebreaker = CodeBreaker.new(COMPUTER)
    else
      @codebreaker = CodeBreaker.new(HUMAN)
      @codemaker = CodeMaker.new(COMPUTER)
    end    
  end

  def play
    guess = nil
    feedback = nil

    @board.display
    @codemaker.make_pattern

    loop do
      guess = @codebreaker.guess_pattern(feedback)
      @board.put(guess, CODEBREAKER)
      @board.display

      feedback = @codemaker.give_feedback(guess)
      @board.put(feedback, CODEMAKER)
      @board.display

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
      @winner = (@player_role == CODEBREAKER) ? @player_name : "COMPUTER"
      true
    elsif @attempts == 0
      @winner = (@player_role == CODEMAKER) ? @player_name : "COMPUTER"
      true
    else
      false
    end
  end
end
