class NaiveStrategy
  def turn(pw)
    available_ships = pw.planets.friendly.ships

    flying_ships = pw.fleets.friendly.size

    return if 1.5 * flying_ships > available_ships

    center = pw.planets.friendly.center

    from_planets = pw.planets.friendly.sort_by{|p| p.strength }.reverse

    if pw.planets.hostile.ships < 0.5 * pw.planets.friendly.ships
      target_planets = pw.planets.hostile
    else
      target_planets = pw.planets.other 
    end

    to = target_planets.sort_by{|p| p.desirability(center)}.reverse

    attacking_planets = (from_planets.length.to_f / 4).ceil 

    from_planets.take(attacking_planets).each do |from|
      count = (from.ships / 2 - from.incoming_hostile)
      next unless count > 0
      pw.issue_order from, to.length > 1 ? to.shift : to.first, count / 2
      pw.issue_order from, to.length > 1 ? to.shift : to.first, count / 2
    end
  end
end
