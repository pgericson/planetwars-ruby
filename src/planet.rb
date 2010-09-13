class Planet
  attr_reader :planet_id, :growth_rate, :x, :y
  attr_accessor :owner, :ships

  def initialize(planet_id, owner, ships, growth_rate, x, y)
    @planet_id, @owner, @ships = planet_id, owner, ships
    @growth_rate, @x, @y = growth_rate, x, y
  end

  def add_ships(n)
    @ships += amt
  end

  def remove_ships(n)
    @ships -= n
  end

  def strength
    @ships / (1 + @growth_rate)
  end
end

