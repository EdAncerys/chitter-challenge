require 'sinatra/base'
require 'sinatra/flash'
require_relative './lib/chitter'

class ChitterApp < Sinatra::Base 
  enable :sessions
  register Sinatra::Flash

  get '/' do
    erb :index
  end

  post '/chitter-post' do
    Chitter.peep_post(peep: params[:peep], user_id: 1)
    redirect '/chitter'
  end

  post '/chitter-delete/:id' do
    Chitter.peep_delete(id: params[:id])
    redirect '/chitter'
  end

  post '/chitter-sort' do
    session[:toggle] = params[:peep_sort]
    redirect '/chitter'
  end

  post '/user/sign-up/new' do
    session[:user_name] = params[:user_name]
    session[:user_email] = params[:user_email]
    redirect '/chitter'
  end

  post '/user/log-in/new' do
    redirect '/chiiter' 
  end

  get '/chitter' do
    session[:toggle] != 'DESC' ? @peeps = Chitter.peep_all : @peeps = Chitter.peep_sort
    @user_name = session[:user_name]
    @user_email = session[:user_email]
    erb :'chitter/index'
  end

  get '/user/sign-up' do
    erb :'users/sign_up'
  end

  get '/user/log-in' do
    erb :'users/log_in'
  end

  get '/chitter/log-out' do
    session.destroy
    redirect '/chitter'
  end

  run! if app_file == $0
end
