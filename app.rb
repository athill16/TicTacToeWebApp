require 'sinatra'

get '/' do
	erb :choose_players
end

post '/input' do
	player_one = params[:player_one]
	player_two = params[:player_two]
	erb :player_one_marker, :locals => {:player_one => player_one, :player_two => player_two}
end

post '/playermarker' do
	choice_for_x = params[:choice_for_x]
	if choice_for_x == "Player one"
		player_one_marker = "X"
		player_two_marker = "O"
	else
		player_one_marker = "O"
		player_two_marker = "X"
	end
	erb :play_game, :locals => {:player_one_marker => player_one_marker, :player_two_marker => player_two_marker}
end


