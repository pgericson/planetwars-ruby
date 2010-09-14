require 'rubygems'
require 'bundler/setup'

require 'sinatra/base'
require 'haml'

class Visualizer < Sinatra::Base
  set :root, File.dirname(__FILE__)

  get '/game/:name' do
    @game = File.read(File.join(Visualizer.root, "games", "#{params[:name]}.game")).gsub(/\n/m, '\n')
    erb :game
  end
end
