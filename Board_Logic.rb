# No input, outputs an array.
def create_new_game_board
	board_array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
end

# Inputs an array, integer, and a string, outputs an array.
def update_game_board(game_board, position, marker)
	game_board[position] = marker
	game_board
end

# Inputs an array and an integer, outputs a boolean.
def valid_position?(game_board, position)
	game_board[position] == position + 1
end

# Inputs an array and a string, outputs a boolean.
def has_game_been_won?(game_board, marker)
	if game_board[0] == marker && game_board[3] == marker && game_board[6] == marker || 
		game_board[1] == marker && game_board[4] == marker && game_board[7] == marker || 
		game_board[2] == marker && game_board[5] == marker && game_board[8] == marker ||
		game_board[0] == marker && game_board[1] == marker && game_board[2] == marker || 
		game_board[3] == marker && game_board[4] == marker && game_board[5] == marker || 
		game_board[6] == marker && game_board[7] == marker && game_board[8] == marker || 
		game_board[0] == marker && game_board[4] == marker && game_board[8] == marker || 
		game_board[2] == marker && game_board[4] == marker && game_board[6] == marker
		true
	else
		false
	end
end

# Inputs an array and a string, outputs a boolean.
def has_game_been_tied?(game_board)
	# Checks if every element in the array is a string to see if there are any moves left.
	game_board.all? do |x| 
		x.is_a?(String) == true
	end
end

# Inputs an array and a string, outputs a boolean.
def game_over?(game_board, marker)
	has_game_been_won?(game_board, marker) ||
	has_game_been_tied?(game_board)
end

def get_available_spaces(game_board)
	available_spaces = []
	game_board.each do |value|
		if value.is_a?(Fixnum)
			available_spaces << value
		end
	end
	available_spaces
end

def display_board(board)
	puts """
	Game Board 
 	 #{board[0]} | #{board[1]} | #{board[2]} 
	-----------
 	 #{board[3]} | #{board[4]} | #{board[5]} 
		-----------
 	 #{board[6]} | #{board[7]} | #{board[8]} 
 	"""
end








