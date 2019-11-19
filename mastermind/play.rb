# sample usage

require_relative("mastermind.rb")

mm = MasterMind.new("Lou", MasterMind::CODEBREAKER, MasterMind::MAX_ATTEMPTS)
mm.play
puts "WINNER: #{mm.winner}"
