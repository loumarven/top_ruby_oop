require_relative "common.rb"

class CodeBreaker
  include Common

  attr_reader :guess

  def initialize(player_type)
    @guess_method = nil
    @guess = nil
    @possible_colors = CODE_PEGS_COLORS

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
    prev_guess = guess
    @guess = []

    if feedback.nil?
      4.times do
        index = rand(CODE_PEGS_COLORS.length)
        @guess.push(CODE_PEGS_COLORS[index])
      end

      return guess
    end

    feedback.each_with_index do |f, index|
      if f == "Black"
        @guess[index] = prev_guess[index]
      elsif f == "White"
        # look for a possible position to swap the prev_guess[index]
        pos = possible_position(feedback, index)
        @guess[index] = prev_guess[pos]
        @guess[pos] = prev_guess[index]
      else
        # try another color from the color choices
        color = possible_color(prev_guess[index])
        @guess[index] = color
      end
    end

    guess
  end

  def human_guess(feedback)
    input = get_input(GUESS)
    @guess = convert_to_colors(input, GUESS)

    guess
  end

  def possible_position(feedback, guess_pos)
    ret = nil

    feedback.each_with_index do |f, index|
      if f == "Blank" ||
         f == "White" && guess_pos != index
        ret = index
        break
      end
    end

    ret
  end

  # TODO: improve algorithm (avoid repeat possible colors)
  def possible_color(color)
    @possible_colors.delete(color)    
    @possible_colors.first
  end
end
