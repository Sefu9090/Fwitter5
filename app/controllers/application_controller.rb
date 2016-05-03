require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "fwitter_secret"
  end

  get '/' do
    @tweets = Tweet.all
    @users = User.all
    erb :index
  end

  get '/tweet' do
    erb :tweet
     if session[:user_id] #returns nil if there isn't one
      erb :tweet
    else
      redirect "/"
    end
  end

  post '/tweet' do
    user = User.find_by(:id => session[:user_id])
    tweet = Tweet.new(:user => user, :status => params[:status])
    tweet.save
    redirect '/'
  end

  get '/users' do
    @users = User.all
    erb :users
  end

  post '/sign-up' do 
    @user = User.new(:username => params[:username], :email => params[:email])
    @user.save
    redirect '/login'
  end
  
  
  get '/login' do
    erb :login
  end
  
  
  post '/login' do
    user = User.find_by(:username => params[:username])
     if user
        session[:user_id] = user.id
        redirect "/"
     else
        redirect "/users"
     end
  end

  get '/logout' do
    session.destroy
    redirect '/'
  end
  
    
  helpers do
    def logged_in?
      session[:user_id]
    end
    
     def current_user
      User.find(session[:user_id])
    end
  end
  
  
end

