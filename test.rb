require 'src/planet_wars'
require 'src/naive_strategy'

pw = PlanetWars.new(File.read("testrun"))
NaiveStrategy.new.turn(pw)
