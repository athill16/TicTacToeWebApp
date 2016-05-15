require_relative "Board_Logic.rb"

class Simple

	def get_move(board)
		array = get_available_spaces(board)
		move = array.sample
	end

end


