# sample usage

require_relative("mastermind.rb")

mm = MasterMind.new("Lou")
mm.player_role = MasterMind::CODEMAKER
mm.play
puts "WINNER: #{mm.winner}"
