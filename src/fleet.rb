class Fleet
  attr_reader :owner, :ships, :source_planet, 
    :destination_planet, :total_trip_length, :turns_remaining
 
   def initialize(owner, ships, source_planet, 
                 destination_planet, total_trip_length, 
                 turns_remaining)
    @owner, @ships = owner, ships
    @source_planet = source_planet
    @destination_planet = destination_planet
    @total_trip_length = total_trip_length
    @turns_remaining = turns_remaining
  end

  class << self
    def parse(tokens)
      raise "Invalid Fleet record" if tokens.length != 7
      Fleet.new(tokens[1].to_i, # owner
                tokens[2].to_i, # num_ships
                tokens[3].to_i, # source
                tokens[4].to_i, # destination
                tokens[5].to_i, # total_trip_length
                tokens[6].to_i) # turns_remaining
    end
  end
end

