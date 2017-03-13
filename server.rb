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

### activate sessions for login purposes
configure do
  enable :sessions
end

### sqlite3 database for development and test
configure :development, :test do
  require 'sqlite3'
  set :database, {adapter: 'sqlite3', database: 'db/barktank.sqlite3'}
end

### PostGRES database configuration for production
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

### Prepare Slack Authentication Request
use OmniAuth::Builder do
  provider :slack, ENV['BARK_TANK_ID'], ENV['BARK_TANK_SECRET'], scope: 'client', team: 'nycda'
end

### Prepare Carrier Wave for Image processing (captured from Slack)
CarrierWave.configure do |config|
  config.root = File.dirname(__FILE__) + "/public"
end

### Load current to manage logins
before do
  # @current_user = User.find_by(slack_uid: session[:slack_uid])
  @current_user = User.find(1)
end

get '/' do
  @projects = Project.order(:order)
  erb :index, locals: {klass: :home}
end


get '/auth/slack/callback' do
  # p "PATH_INFO---------------"
  # pp request.env['PATH_INFO']

  # p "OMNIAUTH.AUTH--------------"
  # pp request.env['omniauth.auth'].inspect
  @current_user = User.find_by(slack_name: request.env['omniauth.auth']['info']['user'])

  # if we weren't able to find you, error out
  unless @current_user
    halt 500
  end

  @current_user.update(
    slack_id: @current_user[:slack_id] || request.env['omniauth.auth']['uid'],
    
  )

  p "UID: #{request.env['omniauth.auth']['uid']}"
  p "----------"
  p "token: #{request.env['omniauth.auth']['credentials']['token']}"
  p "----------"
  p "nickname: #{request.env['omniauth.auth']['info']['nickname']}"
  p "----------"
  p "image: #{request.env['omniauth.auth']['info']['image']}"
  p "----------"
  p "first_name: #{request.env['omniauth.auth']['info']['first_name']}"
  p "last_name: #{request.env['omniauth.auth']['info']['last_name']}"
  #ENV["RACK_ENV"]["omniauth.params"]
  #@user = User.find_by(slack_name: ENV['omniauth.auth']['user']['name'])

  redirect to("/")
end

get '/auth/failure' do
   erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>", locals: {klass: :home} 
end

get '/logout' do
  session[:id] = nil
  redirect to("/")
end

get '/auth/slack/deauthorized' do
  erb "Slack has deauthorized this app.", locals: {klass: :home}
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




