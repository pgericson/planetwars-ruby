class NaiveStrategy
  include Logging

  def turn(pw)
    available_ships = pw.planets.friendly.ships

    flying_ships = pw.fleets.friendly.size

    ratio = pw.planets.friendly.total(:growth_rate) / (1 + pw.planets.hostile.total(:growth_rate))

    return if 1.5 * flying_ships > available_ships

    center = pw.planets.friendly.center

    attack = pw.planets.hostile.ships < ratio * pw.planets.friendly.ships

    target_planets = attack ? pw.planets.hostile : pw.planets.other

    from_planets = pw.planets.friendly.select{|p| p.surplus > 0}.by(:strength).reverse

    attacking_planets = (from_planets.length * 0.25).ceil

    to = target_planets.sort_by{|p| p.desirability(center)}.reverse.take(attacking_planets * 2)
    from_planets = from_planets.take(attacking_planets)

    logger.debug "Attacking: From #{from_planets} to #{to}"

    from = from_planets.shift
    to.each do |target|
      while target.shortfall < 5
        count = [(from.ships * 0.3), (target.ships * 1.1)].min.to_i
        pw.issue_order from, target, count
        if count < target.ships
          return if from_planets.empty?
          from = from_planets.pop
        end
      end
    end
  end
end
