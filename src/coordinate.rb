class Coordinate
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x.to_f, y.to_f
  end

  def +(other)
    Coordinate.new(self.x + other.x, self.y + other.y)
  end

  def -(other)
    Coordinate.new(self.x - other.x, self.y - other.y)
  end

  def / (scalar)
    Coordinate.new(self.x / scalar, self.y / scalar)
  end

  def distance(to)
    Math::hypot( (self.x - to.x), (self.y - to.y) )
  end
end
