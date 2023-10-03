require 'sinatra'

require 'sinatra/flash'
require_relative './lib/wordguesser_game.rb'


class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || WordGuesserGame.new('')
    @game_over = false
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
      @game_over = true
      redirect '/win'
    elsif @game.check_win_or_lose == :lose
      @game_over = true
      redirect '/lose'
    else
      erb :show
    end
  end
  
  get '/win' do
    if @game_over == false
      flash[:message] = "No hagas trampa :3"
      redirect '/show'
    end
    erb :win
  end
  
  get '/lose' do
    if @game_over == false
      redirect '/show'
    end
    erb :lose
  end
end

