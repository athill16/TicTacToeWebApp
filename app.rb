require 'sinatra'
require_relative "Tic_Tac_Toe_Simple_AI.rb"
require_relative "Tic_Tac_Toe_Sequential_AI.rb"

class MyApp < Sinatra::Base

	enable :sessions

	get '/' do
		erb :choose_players
	end

	post '/input' do
		session[:player_one] = params[:player_one]
		session[:player_two] = params[:player_two]
		erb :player_one_marker, :locals => {:player_one => session[:player_one], :player_two => session[:player_two]}
	end

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
		erb :play_game, :locals => {:player_one_marker => session[:player_one_marker], :player_two_marker => session[:player_two_marker], :board => session[:board]}
	end

	post '/startgame' do
		if session[:current_player][:player_mode] == "Human"
			if session[:current_player] == session[:player_one]
				erb :human_game, :locals => {:board => session[:board], :current_player => "Player one"}
			else 
				erb :human_game, :locals => {:board => session[:board], :current_player => "Player two"}
			end
		else
			session[:move] = session[:current_player][:player_mode].get_move(session[:board])
			session[:board] = update_game_board(session[:board], session[:move], session[:current_player][:marker])
			if has_game_been_won?(session[:board], session[:current_player][:marker]) == true
				if session[:current_player] == session[:player_one]
					erb :player_one_wins, :locals => {:board => session[:board]}
				else
					erb :player_two_wins, :locals => {:board => session[:board]}
				end
			elsif has_game_been_tied?(session[:board]) == true
				erb :tie_game, :locals => {:board => session[:board]}
			else
				redirect '/switchplayers'
			end
		end
	end

	get '/switchplayers' do
		if session[:current_player][:player_mode] == "Human"
			redirect '/switchhumanplayers'
		elsif session[:current_player] == session[:player_one]
			session[:current_player] = session[:player_two]
		else
			session[:current_player] = session[:player_one]
		end
		erb :play_game, :locals => {:player_one_marker => session[:player_one_marker], :player_two_marker => session[:player_two_marker], :board => session[:board]}
	end

	get '/switchhumanplayers' do
		if session[:current_player] == session[:player_one]
			session[:current_player] = session[:player_two]
		else
			session[:current_player] = session[:player_one]
		end
		if session[:current_player][:player_mode] != "Human"
			erb :play_game, :locals => {:player_one_marker => session[:player_one_marker], :player_two_marker => session[:player_two_marker], :board => session[:board]}
		elsif session[:current_player] == session[:player_one]
			erb :human_game, :locals => {:board => session[:board], :current_player => "Player one"}
		else 
			erb :human_game, :locals => {:board => session[:board], :current_player => "Player two"}
		end
	end

	post '/humanmove' do
		session[:move] = params[:choice].to_i
		if valid_position?(session[:board], session[:move]) == true
			session[:board] = update_game_board(session[:board], session[:move], session[:current_player][:marker])
			if has_game_been_won?(session[:board], session[:current_player][:marker]) == true
				if session[:current_player] == session[:player_one]
					erb :player_one_wins, :locals => {:board => session[:board]}
				else
					erb :player_two_wins, :locals => {:board => session[:board]}
				end
			elsif has_game_been_tied?(session[:board]) == true
				erb :tie_game, :locals => {:board => session[:board]}
			else
				redirect '/switchhumanplayers'
			end
		else 
			if session[:current_player] == session[:player_one]
				erb :human_game, :locals => {:board => session[:board], :current_player => "Player one"}
			else
				erb :human_game, :locals => {:board => session[:board], :current_player => "Player two"}
			end
		end	
	end
end






