class Planet
  attr_reader :planet_id, :growth_rate, :x, :y
  attr_accessor :owner, :ships

  def initialize(planet_id, owner, ships, growth_rate, x, y)
    @planet_id, @owner, @ships = planet_id, owner, ships
    @growth_rate, @x, @y = growth_rate, x, y
  end

  def strength
    @ships / (1 + @growth_rate)
  end

  class << self
    def parse(id, tokens)
      raise "Invalid Planet record" if tokens.length != 6
      Planet.new(id,
                 tokens[3].to_i, # owner
                 tokens[4].to_i, # num_ships
                 tokens[5].to_i, # growth_rate
                 tokens[1].to_f, # x
                 tokens[2].to_f) # y
    end
  end
end

