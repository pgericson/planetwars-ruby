$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require 'open3'
require 'date'
require 'fileutils'

require 'core_ext'
require 'fight'
require 'fight_aggregator'

include FileUtils::Verbose

def options_from_env
  {
    :map     => ENV['map'] || (maps = Dir.glob('maps/*'))[rand(maps.size)],
    :turns   => ENV['turns'],
    :time    => ENV['time'],
    :against => ENV['against']
  }
end

task :fight do
  @f = Fight.new(options_from_env)
  @f.fight
  puts @f.outcome
end

task :show => :fight do
  @f.show_game
end

task :fightall
task :fightall do
  agg = FightAggregator.new(options_from_env)
  Dir.glob('maps/*').sort.each do |map|
    agg.fight(map)
  end
  agg.summary
end


task :clean do
  rm Dir["visualizer/games/*.game"] rescue nil
end

task :zip do
  rm "bot.zip" if File.exists? "bot.zip"
  cd "src"
  `zip -r ../bot.zip *.rb`
end

