class Planet
  attr_accessor :planet_id, 
    :x,
    :y,
    :growth_rate, 
    :owner, 
    :ships,
    :incoming_friendly,
    :incoming_hostile

  def initialize(planet_id)
    @planet_id = planet_id
  end

  def strength
    @ships / (1 + @growth_rate)
  end

  def update(tokens)
    raise "Invalid Planet record" if tokens.length != 6

    @x = tokens[1].to_f
    @y = tokens[2].to_f
    @owner = tokens[3].to_i
    @ships = tokens[4].to_i
    @growth_rate = tokens[5].to_i
    @incoming_friendly = 0
    @incoming_hostile = 0
  end

  def send_ships(count)
    @ships -= count
  end
  
  def receive_ships(count, from = Ownable::FRIENDLY)
    Log.debug "Planet #{@planet_id}: #{count} ships incoming from #{from}"
    if from == Ownable::FRIENDLY
      @incoming_friendly += count
    else
      @incoming_hostile += count
    end
  end
end

