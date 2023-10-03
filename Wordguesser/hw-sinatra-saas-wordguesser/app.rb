require 'sinatra'

require 'sinatra/flash'
require_relative './lib/wordguesser_game.rb'


class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || WordGuesserGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    word = params[:word] || WordGuesserGame.get_random_word
    @game = WordGuesserGame.new(word)
    redirect '/show'
  end
  
  post '/guess' do
    letter = params[:guess].to_s[0]
    if letter.nil? || letter.empty? || !letter.match?(/[A-Za-z]/)
      flash[:message] = "Invalid guess."
      redirect '/show'
    elsif @game.guess(letter)
      redirect '/show'
    else
      flash[:message] = "You have already used that letter"
      redirect '/show'
    end
  end
  
  get '/show' do
    if @game.check_win_or_lose == :win
      redirect '/win'
    elsif @game.check_win_or_lose == :lose
      redirect '/lose'
    else
      erb :show
    end
  end
  
  get '/win' do
    if @game.check_win_or_lose == :win
      erb :win
    else
      flash[:message] = "No hagas trampa :3"
      redirect '/show'
    end
  end

  get '/lose' do
    if @game.check_win_or_lose == :lose
      erb :lose
    else
      flash[:message] = "Por qué quieres perder? :c"
      redirect '/show'
    end
  end
end

