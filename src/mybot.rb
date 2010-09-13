$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'planet_wars'
require 'naive_strategy'

PlanetWars.play(NaiveStrategy.new)
