class Reinforce
  include Logging
  MAX_PER_PLANET = 0.7

  def turn(world)
    vulnerable = world.planets.friendly.by(:shortfall).reverse.select{|p| p.shortfall > 0 }

    if vulnerable.empty?
      logger.debug "No vulnerable planets, not reinforcing."
      return
    else
      logger.debug "Vulnerable planets: #{vulnerable}"
    end

    reinforcements = (world.planets.friendly - vulnerable).by(:strength)

    if reinforcements.empty?
      logger.debug "No reinforcements available, we're screwed."
      return
    end

    reinforcement = reinforcements.pop
    vulnerable.each do |planet|
      logger.debug "Reinforcing #{planet}"
      while planet.shortfall > 0
        shortfall = planet.shortfall
        ships = [(reinforcement.ships * MAX_PER_PLANET).ceil, shortfall].min 

        world.issue_order reinforcement, planet, ships

        if ships < shortfall
          logger.debug "Depleted reinforcements for #{reinforcement}, moving to next."
          if reinforcements.any?
            reinforcement = reinforcements.pop
          else
            logger.debug "Depleted all reinforcements, we're screwed."
            return
          end
        end
      end
    end
  end
end
