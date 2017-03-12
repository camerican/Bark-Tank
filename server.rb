# server.rb
require 'sinatra'
require 'sinatra/activerecord'
require 'omniauth-slack'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'active_support/all'
require 'action_view'
require 'pp'
require './models'

## Enable ActionView TagHelper
include ActionView::Helpers
## Fix Output Buffer issue
include ActionView::Context
# ref: http://stackoverflow.com/questions/4633493/nested-content-tag-throws-undefined-method-output-buffer-in-simple-helper

configure do
  enable :sessions
end

configure :development, :test do
  require 'sqlite3'
  set :database, {adapter: 'sqlite3', database: 'db/barktank.sqlite3'}
end

configure :production do
  require 'pg'
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb')

  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end

use OmniAuth::Builder do
  provider :slack, ENV['BARK_TANK_ID'], ENV['BARK_TANK_SECRET'], scope: 'client', team: 'nycda'
end

CarrierWave.configure do |config|
  config.root = File.dirname(__FILE__) + "/public"
end

get '/' do
  @projects = Project.order(:order)
  erb :index, locals: {klass: :home}
end


get '/auth/slack/callback' do
  p "PATH_INFO---------------"
  pp request.env['PATH_INFO']

  p "OMNIAUTH.AUTH--------------"
  pp request.env['omniauth.auth'].to_s
  #ENV["RACK_ENV"]["omniauth.params"]
  #@user = User.find_by(slack_name: ENV['omniauth.auth']['user']['name'])

  # redirect to("/")
end

get '/auth/failure' do
   erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>"
end

get '/logout' do
  session[:id] = nil
  redirect to("/")
end

get '/auth/slack/deauthorized' do
  erb "Slack has deauthorized this app."
end

# # projects and handles
# get '/:handle' do
#   # look up projects
#   @project = Project.find_by(short: params[:handle])
#   unless @project && @project.id
#     @profile = User.find_by(slack_name: params[:handle])
#     unless @profile.id
#       halt 404
#     else
#       erb :profile, locals: {klass: :profile}
#     end
#   end
#   erb :project, locals: {klass: :project}
# end




