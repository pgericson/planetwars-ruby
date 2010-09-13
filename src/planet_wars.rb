$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'ownable'
require 'fleet'
require 'fleets'
require 'planet'
require 'planets'

class PlanetWars
  attr_reader :planets, :fleets
  def initialize(game_state)
    parse_game_state(game_state)
  end

  def total_ships_of(player)
    (fleets.of(player) + planets.of(player)).inject(0) {|sum, f| sum + f.ships }
  end

  def distance(source, destination)
    Math::hypot( (source.x - destination.x), (source.y - destination.y) )
  end

  def travel_time(source, destination)
    distance(source, destination).ceil
  end

  def issue_order(source, destination, num_ships)
    puts "#{source.planet_id} #{destination.planet_id} #{num_ships}"
    STDOUT.flush
  end

  def is_alive(player_id)
    (@planets.of(player_id).length > 0) || (@fleets.of(player_id).length > 0)
  end

  def parse_game_state(s)
    @planets = Planets.new
    @fleets = Fleets.new
    lines = s.split("\n")
    planet_id = 0

    lines.each do |line|
      line = line.split("#")[0]
      tokens = line.split(" ")
      next if tokens.length == 1
      if tokens[0] == "P"
        raise "Invalid Planet record" if tokens.length != 6
        p = Planet.new(planet_id,
                       tokens[3].to_i, # owner
                       tokens[4].to_i, # num_ships
                       tokens[5].to_i, # growth_rate
                       tokens[1].to_f, # x
                       tokens[2].to_f) # y
        planet_id += 1
        @planets << p
      elsif tokens[0] == "F"
        raise "Invalid Fleet record" if tokens.length != 7
        f = Fleet.new(tokens[1].to_i, # owner
                      tokens[2].to_i, # num_ships
                      tokens[3].to_i, # source
                      tokens[4].to_i, # destination
                      tokens[5].to_i, # total_trip_length
                      tokens[6].to_i) # turns_remaining
        @fleets << f
      else
        raise "Invalid line"
      end
    end
  end
  
  def game_over?
    planets.friendly.length == 0 || planets.hostile.length == 0
  end

  def finish_turn
    puts "go"
    STDOUT.flush
  end

  class << self
    def turn(map)
      pw = PlanetWars.new(map)
      yield pw unless pw.game_over?
      pw.finish_turn
    end

    def play(strategy)
      loop do
        map = ''
        until map.strip.end_with? "go"
          map << gets
        end

        turn(map) do |pw|
          strategy.turn(pw)
        end
      end
    end
  end
end
