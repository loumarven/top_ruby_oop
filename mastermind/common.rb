module Common
  CODEMAKER = 0
  CODEBREAKER = 1
  HUMAN = 0
  COMPUTER = 1
  CODE_PEGS_COLORS = ["Blank", "Red", "Green", "Blue", "Yellow", "Orange", "Purple"]
  FEEDBACK_COLORS = ["Blank", "Black", "White"]
  MAX_ATTEMPTS = 12
  PATTERN = "pattern"
  GUESS = "guess"
  FEEDBACK = "feedback"

  def get_input(type)
    input = ""

    loop do
      display_colors(type)
      print "Enter #{type} (input numbers corresponding to your #{type}): "
      input = gets.chomp.split('') # string of indexes

      if valid?(input, type)
        break
      else
        puts "Try again!"
      end
    end

    input
  end

  def valid?(input, type)
    indexes = (type == PATTERN || type == GUESS) ? ["0", "1", "2", "3", "4", "5", "6"] : ["0", "1", "2"]

    if input.length != 4
      puts "Invalid input length. Enter four numbers only."
      return false
    end

    input.each do |i|
      if indexes.index(i).nil?
        puts "Invalid input (#{i}). Enter four numbers only."
        return false
      end
    end

    true
  end

  def convert_to_colors(input, type)
    colors = []

    if type == PATTERN || type == GUESS
      input.each do |char|
        index = char.to_i
        colors.push(CODE_PEGS_COLORS[index])
      end
    else
      input.each do |char|
        index = char.to_i
        colors.push(FEEDBACK_COLORS[index])
      end
    end

    colors
  end

  private
  def display_colors(type)
    colors = (type == PATTERN || type == GUESS) ? CODE_PEGS_COLORS : FEEDBACK_COLORS

    colors.each_with_index do |color, index|
      print "| #{index} - #{color} "
    end
    puts "|"
  end
end
