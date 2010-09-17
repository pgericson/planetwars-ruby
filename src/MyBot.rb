$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'planet_wars'
require 'naive_strategy'
require 'logger'

debug = ENV['BOT_DEBUG'] == "true"
Log = debug ? Logger.new("debug.log") : Logger.new(STDERR)

Log.level = debug ? Logger::DEBUG : Logger::UNKNOWN

Log.info "Starting new game"
begin
  PlanetWars.play(NaiveStrategy.new)
rescue Exception => ex
  Log.error ex
end
Log.info "Game over"
