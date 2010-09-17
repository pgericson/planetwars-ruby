$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'planet_wars'
require 'naive_strategy'
require 'logger'

Log = Logger.new("debug.log")
Log.level = Logger::DEBUG

Log.info "Starting new game"
begin
  PlanetWars.play(NaiveStrategy.new)
rescue Exception => ex
  Log.error ex
end
Log.info "Game over"
