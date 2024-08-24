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

	local char_at_cursor = line:sub(current_cursor_pos[2] + 1, current_cursor_pos[2] + 1)
	if char_at_cursor == " " then
		counter = counter - 1
	end
	return { current_cursor_pos[1], word_positions[word_index_cursor + counter][1] }
end

function movements.words(counter)
	return move_across_word_pos(utility.calculate_word_bounds, counter)
end

function movements.WORDS(counter)
	return move_across_word_pos(utility.calculate_WORD_bounds, counter)
end

function move_word_end(word_bound_func, counter)
	local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(current_cursor_pos[1])
	local word_positions = word_bound_func(line)
	local word_index = utility.calculate_word_index_from_cursor_pos(word_positions, current_cursor_pos[2])

	local cursor_is_at_wordend = current_cursor_pos[2] == word_positions[word_index][2] - 1

	if cursor_is_at_wordend then
		counter = counter + 1
	end
	return { current_cursor_pos[1], word_positions[word_index + counter - 1][2] - 1 }
end
function movements.word_end(counter)
	return move_word_end(utility.calculate_word_bounds, counter)
end

function movements.WORD_end(counter)
	return move_word_end(utility.calculate_WORD_bounds, counter)
end

function movements.f(target)
	local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(current_cursor_pos[1])

	for i = current_cursor_pos[2], #line do
		local char = line:sub(i, i)
		if char == target then
			return i
		end
	end
end

function movements.F(target)
	local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(current_cursor_pos[1])

	for i = 0, current_cursor_pos[2] do
		local char = line:sub(i, i)
		if char == target then
			return i - 1
		end
	end
end

function movements.T(target)
	return movements.F(target) + 1
end

local function move_word_start(word_bound_func, counter)
	local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(current_cursor_pos[1])
	local word_positions = word_bound_func(line)
	local word_index = utility.calculate_word_index_from_cursor_pos(word_positions, current_cursor_pos[2])

	local cursor_is_at_word_start = current_cursor_pos[2] == word_positions[word_index][1]
	if cursor_is_at_word_start then
		counter = counter + 1
	end

	return { current_cursor_pos[1], word_positions[word_index - counter - 1][2] - 1 }
end

function movements.word_start(counter)
	return move_word_start(utility.calculate_word_bounds, counter)
end

function movements.WORD_start(counter)
	return move_word_start(utility.calculate_word_bounds, counter)
end

return movements
