class Planets < Array
  include Ownable
  def other
    reject {|planet| planet.owner == 1 }
  end

  def growth_rate
    inject(0) {|sum, p| sum + p.growth_rate}
  end
end
