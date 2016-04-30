require 'sinatra'

get '/' do
	erb :choose_players
end

post '/input' do
	player_one = params[:player_one]
	player_two = params[:player_two]
	erb :player_one_marker,:locals => {:player_one => player_one, :player_two => player_two}
end

