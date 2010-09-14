require 'open3'
require 'date'
require 'fileutils'
include FileUtils::Verbose

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))
require 'core_ext'
require 'fight'
require 'fight_aggregator'

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

task :clean do
  rm Dir["visualizer/games/*.game"] rescue nil
end

task :viz do
  cd "visualizer"
  `script/server > server.log &`
end

task :zip do
  rm "bot.zip" if File.exists? "bot.zip"
  cd "src"
  `zip -r ../bot.zip *.rb`
end

