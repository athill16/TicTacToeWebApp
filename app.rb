require 'sinatra'
require_relative 'TTT_AI_Game.rb'
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
	if session[:player_one] != "Human" && session[:player_two] != "Human"
		if session[:player_one] == "Simple AI"
			player1 = {:player_mode => Simple.new, :marker => session[:player_one_marker]}
		else
			player1 = {:player_mode => Sequential.new, :marker => session[:player_one_marker]}
		end
		if session[:player_two] == "Simple AI"
			player2 = {:player_mode => Simple.new, :marker => session[:player_two_marker]}
		else 
			player2 = {:player_mode => Sequential.new, :marker => session[:player_two_marker]}
		end
		board = create_new_game_board
		board = play_game(player1, player2, board)
		erb :ai_game, :locals => {:player_one_marker => session[:player_one_marker], :player_two_marker => session[:player_two_marker], :player_one => session[:player_one], :player_two => session[:player_two], :board => board}
	elsif session[:player_one] == "Human" && session[:player_two] == "Human"
		erb :human_vs_human_player_one, :locals => {:board => session[:board], :player_one_marker => session[:player_one_marker], :player_two_marker => session[:player_two_marker]}
	elsif session[:player_one] == "Human" && session[:player_two] == "Simple AI"
		erb :human_vs_simple, :locals => {:board => session[:board]}
	elsif session[:player_one] == "Human" && session[:player_two] == "Sequential AI"
		erb :human_vs_sequential, :locals => {:board => session[:board]}
	elsif session[:player_one] == "Simple AI" && session[:player_two] == "Human"
		move = Simple.new.get_move(session[:board])
		session[:board] = update_game_board(session[:board], move-1, session[:player_one_marker])		
		erb :simple_vs_human, :locals => {:board => session[:board]}
	else
		move = Sequential.new.get_move(session[:board])
		board = update_game_board(session[:board], move-1, session[:player_one_marker])				
		erb :sequential_vs_human, :locals => {:board => session[:board]}
	end
end

post '/humanvshuman' do
	array = []
	session[:board].each do |element|
		if element.is_a?(Integer)
			array << element
		end
	end
	array = array.count
	if array % 2 != 0
		space_chosen = params[:choice]
		space_chosen = space_chosen.to_i
		if valid_position?(session[:board], space_chosen-1) == true
			session[:board] = update_game_board(session[:board], space_chosen-1, session[:player_one_marker])  
			if has_game_been_won?(session[:board], session[:player_one_marker]) == true
				erb :player_one_wins, :locals => {:board => session[:board]}
			elsif has_game_been_tied?(session[:board]) == true
				erb :tie_game, :locals => {:board => session[:board]}
			else
				erb :human_vs_human_player_two, :locals => {:board => session[:board], :player_one_marker => session[:player_one_marker], :player_two_marker => session[:player_two_marker]}
			end
		elsif valid_position?(session[:board], space_chosen-1) == false
			erb :human_vs_human_player_one, :locals => {:board => session[:board], :player_one_marker => session[:player_one_marker], :player_two_marker => session[:player_two_marker]}
		end
	elsif array % 2 == 0
		space_chosen = params[:choice]
		space_chosen = space_chosen.to_i
		if valid_position?(session[:board], space_chosen-1) == true
			session[:board] = update_game_board(session[:board], space_chosen-1, session[:player_two_marker])  
			if has_game_been_won?(session[:board], session[:player_two_marker]) == true
				erb :player_two_wins, :locals => {:board => session[:board]}
			elsif has_game_been_tied?(session[:board]) == true
				erb :tie_game, :locals => {:board => session[:board]}
			else
				erb :human_vs_human_player_one, :locals => {:board => session[:board], :player_one_marker => session[:player_one_marker], :player_two_marker => session[:player_two_marker]}
			end
		elsif valid_position?(session[:board], space_chosen-1) == false
			erb :human_vs_human_player_two, :locals => {:board => session[:board], :player_one_marker => session[:player_one_marker], :player_two_marker => session[:player_two_marker]}
		end
	end
end

post '/humanvssimple' do
	space_chosen = params[:choice]
	space_chosen = space_chosen.to_i
	if valid_position?(session[:board], space_chosen-1) == true
		session[:board] = update_game_board(session[:board], space_chosen-1, session[:player_one_marker])
		if has_game_been_won?(session[:board], session[:player_one_marker]) == true
			erb :player_one_wins, :locals => {:board => session[:board]}
		elsif has_game_been_tied?(session[:board]) == true
			erb :tie_game, :locals => {:board => session[:board]}
		else
			move = Simple.new.get_move(session[:board])
			session[:board] = update_game_board(session[:board], move-1, session[:player_two_marker])
			if has_game_been_won?(session[:board], session[:player_two_marker]) == true
				erb :player_two_wins, :locals => {:board => session[:board]}
			elsif has_game_been_tied?(session[:board]) == true
				erb :tie_game, :locals => {:board => session[:board]}
			else
				erb :human_vs_simple, :locals => {:board => session[:board]}
			end	
		end
	elsif valid_position?(session[:board], space_chosen-1) == false
		erb :human_vs_simple, :locals => {:board => session[:board]}
	end
end

post '/humanvssequential' do
	space_chosen = params[:choice]
	space_chosen = space_chosen.to_i
	if valid_position?(session[:board], space_chosen-1) == true
		session[:board] = update_game_board(session[:board], space_chosen-1, session[:player_one_marker])
		if has_game_been_won?(session[:board], session[:player_one_marker]) == true
			erb :player_one_wins, :locals => {:board => session[:board]}
		elsif has_game_been_tied?(session[:board]) == true
			erb :tie_game, :locals => {:board => session[:board]}
		else
			move = Sequential.new.get_move(session[:board])
			session[:board] = update_game_board(session[:board], move-1, session[:player_two_marker])
			if has_game_been_won?(session[:board], session[:player_two_marker]) == true
				erb :player_two_wins, :locals => {:board => session[:board]}
			elsif has_game_been_tied?(session[:board]) == true
				erb :tie_game, :locals => {:board => session[:board]}
			else
				erb :human_vs_sequential, :locals => {:board => session[:board]}
			end	
		end
	elsif valid_position?(session[:board], space_chosen-1) == false
		erb :human_vs_sequential, :locals => {:board => session[:board]}
	end
end

post '/simplevshuman' do 
	space_chosen = params[:choice]
	space_chosen = space_chosen.to_i
	if valid_position?(session[:board], space_chosen-1) == true
		session[:board] = update_game_board(session[:board], space_chosen-1, session[:player_two_marker])
		if has_game_been_won?(session[:board], session[:player_two_marker]) == true
			erb :player_two_wins, :locals => {:board => session[:board]}
		elsif has_game_been_tied?(session[:board]) == true
			erb :tie_game, :locals => {:board => session[:board]}
		else
			move = Simple.new.get_move(session[:board])
			session[:board] = update_game_board(session[:board], move-1, session[:player_one_marker])
			if has_game_been_won?(session[:board], session[:player_one_marker]) == true
				erb :player_one_wins, :locals => {:board => session[:board]}
			elsif has_game_been_tied?(session[:board]) == true
				erb :tie_game, :locals => {:board => session[:board]}
			else
				erb :simple_vs_human, :locals => {:board => session[:board]}
			end	
		end
	elsif valid_position?(session[:board], space_chosen-1) == false
		erb :simple_vs_human, :locals => {:board => session[:board]}
	end
end

post '/sequentialvshuman' do 
	space_chosen = params[:choice]
	space_chosen = space_chosen.to_i
	if valid_position?(session[:board], space_chosen-1) == true
		session[:board] = update_game_board(session[:board], space_chosen-1, session[:player_two_marker])
		if has_game_been_won?(session[:board], session[:player_two_marker]) == true
			erb :player_two_wins, :locals => {:board => session[:board]}
		elsif has_game_been_tied?(session[:board]) == true
			erb :tie_game, :locals => {:board => session[:board]}
		else
			move = Sequential.new.get_move(session[:board])
			session[:board] = update_game_board(session[:board], move-1, session[:player_one_marker])
			if has_game_been_won?(session[:board], session[:player_one_marker]) == true
				erb :player_one_wins, :locals => {:board => session[:board]}
			elsif has_game_been_tied?(session[:board]) == true
				erb :tie_game, :locals => {:board => session[:board]}
			else
				erb :sequential_vs_human, :locals => {:board => session[:board]}
			end	
		end
	elsif valid_position?(session[:board], space_chosen-1) == false
		erb :sequential_vs_human, :locals => {:board => session[:board]}
	end
end








