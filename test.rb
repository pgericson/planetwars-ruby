$LOAD_PATH.unshift("src")

require 'logging'
Logging.setup(:debug => true, :output => STDERR)

require 'planet_wars'
require 'strategies'

include Logging

logger.info "Starting game"

pw = nil
File.open("testrun", "r") do |file|
  pw = PlanetWars.new(file)
  pw.play(Strategies.setup)
end
