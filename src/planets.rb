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
    Log.debug "To: #{to.inspect}"
    to.receive_ships(fleet.size, fleet.owner)
    Log.debug "Received: #{to.inspect}"
  end
end
