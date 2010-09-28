class Planet
  attr_accessor :planet_id, 
    :pos,
    :growth_rate, 
    :owner, 
    :ships,
    :incoming_friendly,
    :incoming_hostile

  def initialize(planet_id)
    @planet_id = planet_id
    @pos = Coordinate.new(0, 0)
  end

  def strength
    @ships + @growth_rate
  end
  
  def start_desirability(from)
    0.7 / (1 + @ships) +
    2.0 * @growth_rate +
    3 / (1 + pos.distance(from))
  end

  def desirability(from)
    0.4 / (1 + @ships) + 
    0.1 * @growth_rate + 
    3 / (1 + pos.distance(from))
  end

  def friendly?
    @owner == Ownable::FRIENDLY
  end

  def hostile?
    @owner > Ownable::FRIENDLY
  end

  def shortfall
    - self.surplus
  end

  def surplus
    @ships - @incoming_hostile + @incoming_friendly
  end

  def update(tokens)
    raise "Invalid Planet record" if tokens.length != 6

    @pos.x = tokens[1].to_f
    @pos.y = tokens[2].to_f
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
    if from == owner
      @incoming_friendly += count
    else
      @incoming_hostile += count
    end
  end

  def to_s
    "<Planet##{@planet_id}: #{@owner}, #{@ships} - #{@incoming_hostile} + #{@incoming_friendly} = #{surplus}>"
  end
end

