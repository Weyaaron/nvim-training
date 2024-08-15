local utility = require("nvim-training.utility")
local movements = {}

function movements.end_of_line()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_current_line()
	local target = #line - 1
	if target == cursor_pos[2] then
		--This prevents starting in the last column
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_pos[2] - 1 })
		target = target - 1
	end

	return { cursor_pos[1], target }
end

local function move_across_word_pos(word_calc_func, counter)
	local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(current_cursor_pos[1])
	local word_positions = word_calc_func(line)
	local word_index_cursor = utility.calculate_word_index_from_cursor_pos(word_positions, current_cursor_pos[2])

	local cursor_is_at_wordend = current_cursor_pos[2] == word_positions[word_index_cursor][2]

	if cursor_is_at_wordend then
		counter = counter + 1
	end
	return { current_cursor_pos[1], word_positions[word_index_cursor + counter][1] }
end

function movements.words(counter)
	return move_across_word_pos(utility.calculate_word_bounds, counter)
end

function movements.WORDS(counter)
	return move_across_word_pos(utility.calculate_WORD_bounds, counter)
end

return movements
