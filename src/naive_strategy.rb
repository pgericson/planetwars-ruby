class NaiveStrategy
  def turn(pw)
    num_fleets = 5

    return unless pw.fleets.friendly.length < num_fleets

    from = pw.planets.friendly.sort_by{|p| p.strength }.last

    to = pw.planets.other.sort_by{|p| p.strength}

    pw.issue_order from, to.shift, from.ships / 3
    pw.issue_order from, to.shift, from.ships / 3
  end
end
