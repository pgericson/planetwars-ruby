$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'logging'
Logging.setup

require 'planet_wars'
require 'strategies'

include Logging

logger.info "Starting new game"

begin
  PlanetWars.play(Strategies.setup)
rescue Exception => ex
  logger.error ex
end

logger.info "Game over"
