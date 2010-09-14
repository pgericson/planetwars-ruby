class FightAggregator
  def initialize(bot1, bot2, options)
    @bot1 = bot1 || DEFAULT_BOT
    @bot2 = bot2 || DEFAULT_BOT
    @options = options
    @fights = []
  end

  def fight(map)
    @fights << f = Fight.new(map, @bot1, @bot2, @options)
    f.fight
  end

  def summary
    puts "Num Fights: #{@fights.size}"
    puts "#{@bot1}:"
    puts "  Wins: #{@fights.select{|f| f.winner == 1}.size}"
    puts "  Avg Turns: #{@fights.select{|f| f.winner == 1}.map{|f| f.turns}.avg}"
    puts "#{@bot2}:"
    puts "  Wins: #{@fights.select{|f| f.winner == 2}.size}"
    puts "  Avg Turns: #{@fights.select{|f| f.winner == 2}.map{|f| f.turns}.avg}"
    puts "Draws: #{@fights.select{|f| f.winner == 0}}"
  end
end
