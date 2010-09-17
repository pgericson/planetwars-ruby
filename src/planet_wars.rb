$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'ownable'
require 'fleet'
require 'fleets'
require 'planet'
require 'planets'

class PlanetWars
  attr_reader :planets, :fleets

  def initialize(input = STDIN)
    @input = input
    @planets = Planets.new
  end
  
  def update(map)
    Log.info "Updating map state"

    @fleets = Fleets.new
    lines = map.split("\n")
    planet_id = 0

    lines.each do |line|
      Log.info "Input: #{line.inspect}"
      line = line.split("#")[0]
      tokens = line.split(" ")
      next if tokens.length == 1
      if tokens[0] == "P"
        @planets[planet_id] ||= Planet.new(planet_id)
        @planets[planet_id].update tokens
        planet_id += 1
      elsif tokens[0] == "F"
        fleet = Fleet.parse(tokens)
        @planets.process_fleet(fleet)
        @fleets << fleet
      else
        raise "Invalid line"
      end
    end
  end

  def total_ships_of(player)
    fleets.of(player).ships + planets.of(player).ships
  end

  def distance(source, destination)
    Math::hypot( (source.x - destination.x), (source.y - destination.y) )
  end

  def travel_time(source, destination)
    distance(source, destination).ceil
  end

  def issue_order(source, destination, count)
    source.send_ships(count)
    destination.receive_ships(count)
    order = "#{source.planet_id} #{destination.planet_id} #{count}"
    Log.info "Order: #{order}"
    puts order
  end

  def is_alive(player_id)
    (@planets.of(player_id).length > 0) || (@fleets.of(player_id).length > 0)
  end

  def game_over?
    planets.friendly.length == 0 || planets.hostile.length == 0
  end

  def go
    Log.info "Go."
    puts "go"

    STDOUT.flush
  end

  def play(strategy)
    @turn = 0
    loop do
      Log.info "Turn #{@turn}"
      map = ''
      until map.strip.end_with? "go"
        line = @input.gets
        return if line.nil?
        map << line
      end

      update(map)
      Log.debug "World: #{self.inspect}"

      Log.info "Playing #{strategy}"
      strategy.turn(self) unless game_over?

      go

      @turn += 1
    end
  end

  class << self
    def play(strategy)
      self.new.play(strategy)
    end
  end
end
