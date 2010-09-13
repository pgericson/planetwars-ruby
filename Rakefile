require 'open3'

class Fight
  attr_reader :turns
  attr_reader :winner

  DEFAULT_BOT = "src/MyBot.rb"

  def initialize(map, bot1, bot2, options = {})
    @map = map
    @bot1 = bot1 || DEFAULT_BOT
    @bot2 = bot2 || DEFAULT_BOT
    @visualize = options.include?(:visualize) ? options[:visualize] : true
    @turns = options[:turns] || 1000
    @quiet = options[:quiet]
  end

  def bot_command(bot)
    if bot =~ /.jar/
      "java -jar #{bot}"
    elsif bot =~ /.rb/
      "ruby #{bot}"
    else
      raise "Unknown bot type."
    end
  end

  def fight
    puts "Map #{@map}"
    puts "#{@bot1} vs #{@bot2}"
    play_game
    parse_output
    visualize if @visualize
  end

  private

  def play_game
    cmd = [
      "java -jar tools/PlayGame.jar #{@map} 90000 #{@turns} game.log",
      "\"#{bot_command(@bot1)}\"",
      "\"#{bot_command(@bot2)}\""
    ].join(' ')
    lines = []
    Open3.popen3(cmd) do |stdin, stdout, stderr|
      err_thread = Thread.new do
        while !stderr.eof?
          line = stderr.readline
          puts line unless @quiet
          lines << line
        end
      end

      out_thread = Thread.new do
        @output = stdout.readlines
      end

      err_thread.join
      out_thread.join
    end
    @errput = lines
  end

  def visualize
    p = IO.popen("java -jar tools/ShowGame.jar", 'w')
    p.write(@output)
    p.close
  end

  def parse_output
    @turns = @errput[-2].match(/Turn (\d+)/)[1].to_i
    if @errput[-1].match(/Draw/)
      @winner = 0
    else
      @winner = @errput[-1].match(/Player (\d)/)[1].to_i
    end
  end

end

class Array
  def avg
    return 0 if self.empty?
    self.inject(0) {|t, i| t + i} / self.size
  end
end

class FightAggregator
  def initialize(bot1, bot2, options)
    @bot1 = bot1
    @bot2 = bot2
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
    puts "Draws: #{@fights.select{|f| f.winner == 0}.map{|f| f.turns}.avg}"
  end
end

def options_from_env
  options = {}
  options[:visualize] = ENV['vis'] == 'true' if ENV.include?('vis')
  options[:turns] = ENV['turns']
  options[:time] = ENV['time']
  options
end

task :fight do
  map = ENV['map'] || (maps = Dir.glob('maps/*'))[rand(maps.size)]
  bot1 = ENV['bot1']
  bot2 = ENV['bot2']
  options = options_from_env
  f = Fight.new(map, bot1, bot2, options)
  f.fight
end

task :fightall
task :fightall do
  bot1 = ENV['bot1']
  bot2 = ENV['bot2']
  options = options_from_env
  options[:visualize] = false
  agg = FightAggregator.new(bot1, bot2, options)
  Dir.glob('maps/*').sort.each do |map|
    agg.fight(map)
  end
  agg.summary
end

task 'build/zip' do
  `mkdir -p build/zip`
end

task :zip do
  `rm bot.zip` if File.exists?('bot.zip')
  Dir.chdir('src')
  `zip -r ../bot.zip *.rb`
end

