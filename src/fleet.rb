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
end

