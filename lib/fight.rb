class Fight
  attr_reader :turns
  attr_reader :winner

  DEFAULT_BOT = "src/MyBot.rb"

  def initialize(map, bot1, bot2, options = {})
    @map = map
    @bot1 = bot1 || DEFAULT_BOT
    @bot1_name = File.basename(@bot1)
    @bot2 = bot2 || DEFAULT_BOT
    @bot2_name = File.basename(@bot2)
    @visualize = options[:visualize]
    @turns = options[:turns] || 1000
    @time = DateTime.now
    @game_file = game_file
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
    puts "#{@bot1_name} vs #{@bot2_name}"
    play_game
    parse_output
    save_game
    show_game if @visualize
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
          puts line if Rake.application.options.trace
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

  def save_game
    File.open(@game_file, "w") do |f|
      f.write("player_one=#{@bot1_name}\nplayer_two=#{@bot2_name}\nplayback_string=")
      f.write(@output)
    end
  end

  def show_game
    `gnome-open http://localhost:9393/game/#{File.basename(@game_file)}`
  end

  def parse_output
    @turns = @errput[-2].match(/Turn (\d+)/)[1].to_i
    if @errput[-1].match(/Draw/)
      @winner = 0
    else
      @winner = @errput[-1].match(/Player (\d)/)[1].to_i
    end
  end

  def game_file
    mapname = File.basename(@map)
    time = @time.strftime("%Y-%m-%d_%H.%m.%S")

    "visualizer/games/#{@bot1_name}_vs_#{@bot2_name}_on_#{mapname}_#{time}.game"
  end
end
