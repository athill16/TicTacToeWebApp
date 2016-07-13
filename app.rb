require 'sinatra'
require_relative "Tic_Tac_Toe_Simple_AI.rb"
require_relative "Tic_Tac_Toe_Sequential_AI.rb"

class MyApp < Sinatra::Base

	enable :sessions

	get '/' do
		erb :choose_players
	end

	post '/chooseplayertypes' do
		session[:player_one] = params[:player_one]
		session[:player_two] = params[:player_two]
		# redirect '/playermarker?player_one=' + session[:player_one] + '&player_two=' + session[:player_two]	
		if session[:player_one] == "Human" && session[:player_two] == "Human"
			erb :ask_players_for_names
		elsif session[:player_one] == "Human"
			session[:player_two_name] = session[:player_two]
			erb :ask_player_one_for_name
		elsif session[:player_two] == "Human"
			session[:player_one_name] = session[:player_one]			
			erb :ask_player_two_for_name
		else 
			session[:player_one_name] = session[:player_one]
			session[:player_two_name] = session[:player_two]
			erb :player_one_marker, :locals => {:player_one_name => session[:player_one_name], :player_two_name => session[:player_two_name]}
		end
	end

	post '/getplayernames' do
		session[:player_one_name] = params[:player_one_name]
		session[:player_two_name] = params[:player_two_name]
		erb :player_one_marker, :locals => {:player_one_name => session[:player_one_name], :player_two_name => session[:player_two_name]}
	end

	post '/getplayeronename' do
		session[:player_one_name] = params[:player_one_name]
		erb :player_one_marker, :locals => {:player_one_name => session[:player_one_name], :player_two_name => session[:player_two_name]}
	end

	post '/getplayertwoname' do
		session[:player_two_name] = params[:player_two_name]
		erb :player_one_marker, :locals => {:player_one_name => session[:player_one_name], :player_two_name => session[:player_two_name]}
	end

	# get '/playermarker' do 
	# 	session[:player_one] = params[:player_one]
	# 	session[:player_two] = params[:player_two]
	# 	erb :player_one_marker, :locals => {:player_one => session[:player_one], :player_two => session[:player_two]}
	# end

	post '/playermarker' do
		choice_for_x = params[:choice_for_x]
		if choice_for_x == "player_one"
			session[:player_one_marker] = "X"
			session[:player_two_marker] = "O"
		else
			session[:player_one_marker] = "O"
			session[:player_two_marker] = "X"
		end
		session[:board] = create_new_game_board
		if session[:player_one] == "Human" 
			session[:player_one] = {:player_mode => "Human", :marker => session[:player_one_marker]}
		elsif session[:player_one] == "Simple AI"
			session[:player_one] = {:player_mode => Simple.new, :marker => session[:player_one_marker]}
		else
			session[:player_one] = {:player_mode => Sequential.new, :marker => session[:player_one_marker]}
		end
		if session[:player_two] == "Human" 
			session[:player_two] = {:player_mode => "Human", :marker => session[:player_two_marker]}
		elsif session[:player_two] == "Simple AI"
			session[:player_two] = {:player_mode => Simple.new, :marker => session[:player_two_marker]}
		else
			session[:player_two] = {:player_mode => Sequential.new, :marker => session[:player_two_marker]}
		end
		session[:board] = create_new_game_board
		session[:current_player] = session[:player_one]
		redirect '/startgame'
	end

	get '/startgame' do
		if session[:current_player][:player_mode] == "Human"
			if session[:current_player] == session[:player_one]
				erb :human_game, :locals => {:board => session[:board], :current_player => session[:player_one_name]}
			else 
				erb :human_game, :locals => {:board => session[:board], :current_player => session[:player_two_name]}
			end
		else
			session[:move] = session[:current_player][:player_mode].get_move(session[:board])
			session[:board] = update_game_board(session[:board], session[:move], session[:current_player][:marker])
			if has_game_been_won?(session[:board], session[:current_player][:marker]) == true
				if session[:current_player] == session[:player_one]
					erb :winner, :locals => {:board => session[:board], :player => session[:player_one_name]}
				else
					erb :winner, :locals => {:board => session[:board], :player => session[:player_two_name]}
				end
			elsif has_game_been_tied?(session[:board]) == true
				erb :tie_game, :locals => {:board => session[:board]}
			else
				redirect '/switchplayers'
			end
		end
	end

	get '/switchplayers' do
		if session[:current_player] == session[:player_one]
			session[:current_player] = session[:player_two]
		else
			session[:current_player] = session[:player_one]
		end
		if session[:current_player] == session[:player_one]
			erb :human_game, :locals => {:board => session[:board], :current_player => session[:player_one_name]}
		else 
			erb :human_game, :locals => {:board => session[:board], :current_player => session[:player_two_name]}
		end
	end

	post '/humanmove' do
		session[:move] = params[:choice].to_i-1
		if valid_position?(session[:board], session[:move]) == true
			session[:board] = update_game_board(session[:board], session[:move], session[:current_player][:marker])
			if has_game_been_won?(session[:board], session[:current_player][:marker]) == true
				if session[:current_player] == session[:player_one]
					erb :winner, :locals => {:board => session[:board], :player => session[:player_one_name]}
				else
					erb :winner, :locals => {:board => session[:board], :player => session[:player_two_name]}
				end
			elsif has_game_been_tied?(session[:board]) == true
				erb :tie_game, :locals => {:board => session[:board]}
			else
				redirect '/switchplayers'
			end
		else 
			if session[:current_player] == session[:player_one]
				erb :human_game, :locals => {:board => session[:board], :current_player => session[:player_one_name]}
			else
				erb :human_game, :locals => {:board => session[:board], :current_player => session[:player_two_name]}
			end
		end	
	end

	post '/newgame' do
		redirect '/'
	end

end





