require_relative "Board_Logic.rb"

class Sequential

	def get_move(board)
		array = get_available_spaces(board)
		move = array[0]
	end

end



