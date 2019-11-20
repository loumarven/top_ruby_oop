require_relative "common.rb"

class CodeMaker
  include Common

  attr_reader :pattern, :feedback

  def initialize(player_type)
    @pattern_method = nil
    @feedback_method = nil
    @pattern = nil
    @feedback = nil

    if player_type == COMPUTER
      @pattern_method = -> {computer_pattern}
      @feedback_method = -> (guess) {computer_feedback guess}
    else
      @pattern_method = -> {human_pattern}
      @feedback_method = -> (guess) {human_feedback guess}
    end
  end

  def make_pattern
    @pattern_method.call
  end

  def give_feedback(guess)
    @feedback_method.call(guess)
  end

  private
  def computer_pattern
    @pattern = []

    4.times do
      index = rand(CODE_PEGS_COLORS.length)
      @pattern.push(CODE_PEGS_COLORS[index])
    end

    pattern
  end

  def human_pattern
    input = get_input(PATTERN)
    @pattern = convert_to_colors(input, PATTERN)

    pattern
  end

  def computer_feedback(guess)
    @feedback = Array.new(4, nil)
    colors_state = []

    @pattern.each do |color|
      colors_state.push([color, -1])
    end

    # check for exact matches first
    guess.each_with_index do |color, index|
      if color == @pattern[index]
        @feedback[index] = "Black"
        colors_state[index][1] = 0
      end
    end

    # now set the whites and blanks ("-")
    @feedback.each_with_index do |status, index|
      if status.nil? # meaning, no feedback yet for the guess
        match = colors_state.index([guess[index], -1])
        if match
          @feedback[index] = "White"
          colors_state[match][1] = 0
        else
          @feedback[index] = "-"
        end
      end
    end

    feedback
  end

  def human_feedback(guess)
    input = get_input(FEEDBACK)
    @feedback = convert_to_colors(input, FEEDBACK)

    feedback
  end
end
