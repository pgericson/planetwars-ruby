require 'src/planet_wars'
require 'src/naive_strategy'
require 'logger'

Log = Logger.new(STDOUT)

Log.info "Starting game"
File.open("testrun", "r") do |file|
  pw = PlanetWars.new(file)
  pw.play(NaiveStrategy.new)
end
