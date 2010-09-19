class Fights
  def initialize(array = [])
    @array = array
  end

  def method_missing(method, *args, &block)
    @array.send(method, *args, &block)
  end

  def select(&block)
    @array.select(&block)
  end

  def winner(num)
    Fights.new(select {|f| f.winner == num})
  end

  def turns
    map {|f| f.turns}
  end
end

class FightAggregator
  def initialize(options = {})
    @options = options
    @shell = options[:shell]
    @fights = Fights.new
  end

  def fight(map)
    @fights << f = Fight.new(@options.merge({:map => map}))
    f.fight
  end

  def summary
    bot = @fights.first.bots.first
    opponent = @fights.first.bots.last

    @shell.say @shell.set_color("Total rounds: #{@fights.size}", nil, true)
    @shell.print_table [
      ["Bot", "Wins", "Turns"],
      [bot.name, @fights.winner(1).size, @fights.winner(1).turns.avg],
      [opponent.name, @fights.winner(2).size, @fights.winner(2).turns.avg],
      ["Draw", @fights.winner(0).size, @fights.winner(0).turns.avg]
    ]
  end
end
