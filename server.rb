# server.rb
require 'sinatra'
require 'sinatra/activerecord'
require 'omniauth-slack'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'active_support/all'
require 'action_view'
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
  provider :slack, ENV['BARK_TANK_ID'], ENV['BARK_TANK_SECRET'], scope: 'identity.basic'
end

CarrierWave.configure do |config|
  config.root = File.dirname(__FILE__) + "/public"
end

get '/' do
  @projects = Project.order(:order)
  erb :index, locals: {klass: :home}
end


get '/auth/slack/callback' do
  p response
  request.env["omniauth.params"]
  #@user = User.find_by(slack_name: ENV['omniauth.auth']['user']['name'])

 # ENV['omniauth.auth']
  # # env['omniauth.auth']
  #  p "detected provider #{env['omniauth.auth']['provider']}"
  #   oa_account = DB[:oa_account].where(id: env['omniauth.auth']['uid']).where(type: env['omniauth.auth']['provider'])
  #   p oa_account.to_a
  #   if 1 != oa_account.update(token: env['omniauth.auth']['credentials']['token']) && oa_account.to_a.length < 1

  #     # try to find a user account linked to this oa_account...  if not found, this oa_account
  #     # will be treated as a provisional application for a user account.  An administrator 
  #     # can then link an oa_account to a user account
  #     names = env['omniauth.auth']['extra']['raw_info']['name'].split(" ")
  #     n_m = nil
  #     n_m = names[1..-2].join(' ') if names && names.length >= 2
  #     img = open(env['omniauth.auth']['info']['image'], :allow_redirections => :safe).base_uri.to_s
  #     IO.copy_stream(open(img), "public/img/#{env['omniauth.auth']['provider']}/#{env['omniauth.auth']['uid']}.jpg")

  #     p env['omniauth.auth']

  #     #let's create a user account for this person...
  #     n_f = env['omniauth.auth']['info']['first_name']
  #     n_f = env['omniauth.auth']['extra']['raw_info']['first_name'] if n_f.nil? || n_f.length < 0
  #     n_l = env['omniauth.auth']['info']['last_name']
  #     n_l = env['omniauth.auth']['extra']['raw_info']['last_name'] if n_l.nil? || n_l.length < 0

  #     user = DB[:user].where(
  #       email: env['omniauth.auth']['info']['email']
  #     ).first
  #     if( user.nil? ) 
  #       user_id = DB[:user].insert(
  #         n_f: n_f,
  #         n_l: n_l,
  #         email: env['omniauth.auth']['info']['email']
  #       )
  #     else
  #       user_id = user[:id]
  #     end

  #     #and then the oa_account linked to the user
  #     DB[:oa_account].update(
  #       id:    env['omniauth.auth']['uid'],
  #       type:  env['omniauth.auth']['provider'], 
  #       user:  user_id,
  #       token: env['omniauth.auth']['credentials']['token'],
  #       uri:   auth_uri_helper(env['omniauth.auth']),
  #       img:   img,
  #       email: env['omniauth.auth']['info']['email'],
  #       n_f:   n_f, #names[0],
  #       n_l:   n_l, #names[-1],
  #       n_n:   env['omniauth.auth']['info']['nickname'],
  #       n_m:   n_m,
  #       location: env['omniauth.auth']['info']['location']
  #     )
 
  #     #load the account
  #     oa_account = DB[:oa_account].where(id: env['omniauth.auth']['uid']).where(type: env['omniauth.auth']['provider'])
  #     session[:id] = user_id
  #   else
  #     # if we already had a record to update, check to see whether the user link exists so we can mark them 
  #     # as a logged in AND registered user
  #     p "setting session id: #{oa_account[:user][:user]}"
  #     session[:id] = oa_account[:user][:user] unless oa_account.nil? || oa_account[:user].nil?
  #   end

  #   #push through to the session
  #   oa = oa_account.first
  #   p "oa = #{oa}"
  #   p "oa[:type] = #{oa[:type]}"
  #   p "oa[:type].to_sym = #{oa[:type].to_sym}"
  #   session[:oa] ||= {}
  #   session[:oa][oa[:type].to_sym] = oa[:id]
  # end

  # redirect to("/")
end



# projects and handles
get '/:handle' do
  # look up projects
  @project = Project.find_by(short: params[:handle])
  unless @project.id
    @profile = User.find_by(slack_name: params[:handle])
    unless @profile.id
      halt 404
    else
      erb :profile, locals: {klass: :profile}
    end
  end
  erb :project, locals: {klass: :project}
end




