require_relative("common.rb")

class Board
  include Common

  attr_reader :guesses, :feedbacks

  def initialize(attempts)
    @attempts = attempts
    @guesses = Array.new(attempts, Array.new(4, ""))
    @feedbacks = Array.new(attempts, Array.new(4, ""))
    @guess_index = 0
    @feedback_index = 0
  end

  def display
    lwidth = 94

    system("clear")
    puts
    puts "#{'MASTERMIND GAME'.center(lwidth)}"
    puts

    print "#{'GUESSES'.center(37)}"
    print "                    "
    puts "#{'FEEDBACKS'.center(37)}"

    board_index = @attempts - 1

    board_index.downto(0) do |index|
      4.times { |color| print "|#{@guesses[index][color].center(8)}" }
      print "|"
      print "                    "
      4.times { |color| print "|#{@feedbacks[index][color].center(8)}" }
      puts "|"
    end
  end

  def put(code, player_role)
    puts

    if player_role == CODEBREAKER
      @guesses[@guess_index] = code
      @guess_index += 1
    else
      @feedbacks[@feedback_index] = code
      @feedback_index += 1
    end 
  end
end
