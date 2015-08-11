require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'sinatra/flash'
require './models'

set :database, "sqlite3:sinApp_dev.sqlite3"
set :sessions, true

enable :sessions

get '/' do
  # User.create(email: 'hello@world.com')
  # @users = User.all
  erb :index
end

post '/sign-in' do
  puts "params are" + params.inspect
  @user = User.where(username: params[:username]).first
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    puts "This session beloings to" + session[:user_id].to_s + "aka" + @user.username
    # flash[:notice] = "You've been signed in successfully."
    redirect '/hello'
  else
    # flash[:alert] = "There was a problem signing you in."
    redirect 'login-failed'
  end
end

get '/hello' do
  @user = current_user
  erb :hello
end

get '/login-failed' do
  erb :login_failed
end


def current_user
  if session[:user_id]
    @current_user = User.find(session[:user_id])
  end
end
