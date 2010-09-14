class Planets
  include Ownable
  def other
    wrap(reject {|planet| planet.owner == 1 })
  end

  def growth_rate
    total :growth_rate
  end
end
