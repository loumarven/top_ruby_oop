require_relative "common.rb"

class CodeBreaker
  include Common

  attr_reader :guess

  def initialize(player_type)
    @guess_method = nil
    @guess = nil

    if player_type == COMPUTER
      @guess_method = -> (feedback) {computer_guess feedback}
    else
      @guess_method = -> (feedback) {human_guess feedback}
    end
  end

  def guess_pattern(feedback)
    @guess_method.call(feedback)
  end

  private
  def computer_guess(feedback)
    # TODO
  end

  def human_guess(feedback)
    input = get_input(GUESS)
    @guess = convert_to_colors(input, GUESS)

    guess
  end
end
