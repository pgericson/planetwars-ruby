require 'thor/shell'

class Fight
  attr_reader :turns
  attr_reader :winner
  attr_reader :bots

  def initialize(options = {})
    @map = options[:map] || (maps = Dir.glob('maps/*'))[rand(maps.size)]
    @bots = [
      Bot.new(options[:bot] || Bot::DEFAULT_BOT),
      Bot.new(options[:opponent] || Bot::DEFAULT_OPPONENT)
    ]
    @turns = options[:turns] || 500
    @verbose = options[:verbose]
    @shell = options[:shell] || Thor::Shell::Color.new

    @time = DateTime.now
    @game_file = game_file
  end


  def fight
    @shell.say @shell.set_color("#{@bots[0].name} vs #{@bots[1].name} on #{@map}", nil, true)
    play_game
    parse_output
    @shell.say *self.outcome
    save_game
  end

  def show_game
    `gnome-open http://localhost:9393/game/#{File.basename(@game_file)}`
  end

  def outcome
    {
      0 => ["Draw.", :yellow],
      1 => ["#{@bots[0].name} wins.", :green],
      2 => ["#{@bots[1].name} wins.", :red]
    }[@winner]
  end

  private

  def play_game
    cmd = [
      "java -jar tools/PlayGame.jar #{@map} 90000 #{@turns} game.log",
      "\"#{@bots[0].command}\"",
      "\"#{@bots[1].command}\""
    ].join(' ')
    lines = []
    Open3.popen3(cmd) do |stdin, stdout, stderr|
      err_thread = Thread.new do
        while !stderr.eof?
          line = stderr.readline
          if @verbose
            @shell.puts line 
          else
            if line =~ /Turn (\d+)/
              @shell.say ".", nil, false
            end
          end
          lines << line
        end
        puts
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
      f.write("player_one=#{@bots[0].name}\nplayer_two=#{@bots[1].name}\nplayback_string=")
      f.write(@output)
    end
  end


  def parse_output
    return unless @errput[-2] =~ /Turn (\d+)/
    @turns = $1.to_i
    if @errput[-1].match(/Draw/)
      @winner = 0
    else
      @winner = @errput[-1].match(/Player (\d)/)[1].to_i
    end
  end

  def game_file
    mapname = File.basename(@map)
    time = @time.strftime("%Y-%m-%d_%H.%M.%S")

    "visualizer/games/#{time}__#{@bots[1].name}_on_#{mapname}.game"
  end
end
