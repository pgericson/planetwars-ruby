class Planets
  include Ownable
  def other
    wrap(reject {|planet| planet.owner == 1 })
  end

  def growth_rate
    total :growth_rate
  end

  def process_fleet(fleet)
    to = self[fleet.destination]
    to.receive_ships(fleet.size, fleet.owner)
  end

  def center
    self.inject(Coordinate.new(0,0)) do |sum, planet|
      sum + planet.pos
    end / self.length
  end
end
