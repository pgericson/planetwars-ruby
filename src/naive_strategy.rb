class NaiveStrategy
  def turn(pw)
    available_ships = pw.planets.friendly.ships

    flying_ships = pw.fleets.friendly.size

    return if flying_ships > available_ships

    from = pw.planets.friendly.sort_by{|p| p.strength }.last

    to = pw.planets.other.sort_by{|p| p.strength}

    pw.issue_order from, to.shift, from.ships / 3
    pw.issue_order from, to.shift, from.ships / 3
  end
end
