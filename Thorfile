$LOAD_PATH.unshift("lib")
require "open3"
require "date"
require "fileutils"
require "core_ext"
require "bot"
require "fight"
require "fight_aggregator"

class Default < Thor
  include Thor::Actions
  include FileUtils::Verbose

  desc "clean", "Remove all game files."
  def clean
    rm(Dir["visualizer/games/*.game"]) rescue nil
  end

  desc "fight [OPPONENT]", "Pit your bot against opponent on a random map"
  method_options :show => false, :map => :string, :turns => 500, :verbose => false
  def fight(opponent = Bot::DEFAULT_OPPONENT)
    @f = Fight.new(options.merge({:opponent => opponent, :shell => self.shell}))
    @f.fight
  end

  desc "fightall [OPPONENT]", "Fight on all maps"
  method_options :turns => 500, :maps => "maps/*"
  def fightall(opponent = Bot::DEFAULT_OPPONENT)
    agg = FightAggregator.new(options.merge({:opponent => opponent, :shell => self.shell}))
    begin
      Dir.glob(options.maps).sort.each do |map| 
        agg.fight(map) 
      end
    rescue Interrupt
      say
    end
    agg.summary
  end

  desc "zip", "Bundle the bot as a zip file for submission"
  def zip
    rm("bot.zip") if File.exists?("bot.zip")
    cd("src")
    `zip -r ../bot.zip *.rb`
  end
end
