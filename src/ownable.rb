module Ownable
  NEUTRAL = 0
  FRIENDLY = 1

  def initialize(array = nil)  
    @array = array || []
  end

  def to_ary
    @array
  end

  def to_s
    @array.map {|p| p.to_s}.join(", ")
  end

  def respond_to?(method)
    super || @array.respond_to?(method)
  end

  def method_missing(method, *args, &block)
    # puts "method_missing(#{method.inspect}, #{args.inspect}, #{block.inspect})"
    if @array.respond_to?(method)
      wrap @array.send(method, *args, &block)
    else
      super
    end
  end

  # Explicitly delegate select, since Kerner#select exists
  def select(&block)
    wrap @array.select(&block)
  end

  def wrap(object)
    object.is_a?(Array) ? self.class.new(object) : object
  end

  def total(attribute)
    inject(0) {|sum, item| sum + item.send(attribute)}
  end

  def of(player = nil)
    return select {|item| yield(item.owner) } if block_given?
    return select {|item| item.owner == player } if player
  end

  def by(attribute)
    sort_by {|item| item.send(attribute) }
  end

  def ships
    total :ships
  end

  def friendly
    of FRIENDLY
  end

  def neutral
    of NEUTRAL
  end

  def hostile
    of {|player| player > FRIENDLY }
  end
end
