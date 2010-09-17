class Fleet
  attr_accessor :owner, 
    :size, 
    :source, 
    :destination, 
    :trip_length, 
    :turns_remaining
 
  def initialize
    yield self
  end

  class << self
    def parse(tokens)
      raise "Invalid Fleet record" if tokens.length != 7
      self.new do |f|
        f.owner = tokens[1].to_i
        f.size = tokens[2].to_i
        f.source = tokens[3].to_i
        f.destination = tokens[4].to_i
        f.trip_length = tokens[5].to_i
        f.turns_remaining = tokens[6].to_i
      end
    end
  end
end

