require 'rubygems'
require 'bundler/setup'

require 'sinatra/base'
require 'haml'

class Visualizer < Sinatra::Base
  set :root, File.dirname(__FILE__)

  def games_dir(path = '')
    File.join(Visualizer.root, "games", path)
  end

  get '/' do
    @games = Dir.glob(games_dir('*.game')).map {|game| File.basename(game) }
    erb :index
  end

  get '/game/:name' do
    @game_name = params[:name]
    @game = File.read(games_dir("#{@game_name}")).gsub(/\n/m, '\n')
    erb :game
  end
end
