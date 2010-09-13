module Ownable
  NEUTRAL = 0
  FRIENDLY = 1

  def of(player)
    wrap select {|item| item.owner == player }
  end

  def friendly
    wrap of(FRIENDLY)
  end

  def neutral
    wrap of(NEUTRAL)
  end

  def hostile
    wrap select {|item| item.owner > 1 }
  end

  def wrap(array)
    wrapped = self.class.new
    array.each { |item| wrapped << item }
    wrapped
  end
end
