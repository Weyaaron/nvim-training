local utility = require("nvim-training.utility")
local movements = {}

function movements.end_of_line(line, cursor_pos)
	return #line - 1
end

--This function may wrap to show that the computation failed.
local function move_across_word_pos(line, cursor_pos, word_calc_func, counter)
	local word_positions = word_calc_func(line)
	--This index respects that we might be between words and assigns the rightmost word completly left of the cursor in this case.
	local word_index_cursor = utility.calculate_word_index_from_cursor_pos(word_positions, cursor_pos)

	local new_word_index = word_index_cursor + counter
	if new_word_index > #word_positions then
		return -1
	end
	return word_positions[new_word_index][1]
end

function movements.words(line, cursor_pos, counter)
	return move_across_word_pos(line, cursor_pos, utility.calculate_word_bounds, counter)
end

function movements.WORDS(line, cursor_pos, counter)
	return move_across_word_pos(line, cursor_pos, utility.calculate_WORD_bounds, counter)
end

local function move_word_end(line, cursor_pos, word_bound_func, counter)
	local word_positions = word_bound_func(line)
	local word_index = utility.calculate_word_index_from_cursor_pos(word_positions, cursor_pos)

	local cursor_is_at_wordend = cursor_pos == word_positions[word_index][2]
	local char_at_cursor = line:sub(cursor_pos + 1, cursor_pos + 1)
	if char_at_cursor == " " then
		counter = counter + 1
	end

	if cursor_is_at_wordend then
		counter = counter + 1
	end
	local new_word_index = word_index + counter - 1
	return word_positions[new_word_index][2]
end
function movements.word_end(line, cursor_pos, counter)
	return move_word_end(line, cursor_pos, utility.calculate_word_bounds, counter)
end

function movements.WORD_end(line, cursor_pos, counter)
	return move_word_end(line, cursor_pos, utility.calculate_WORD_bounds, counter)
end

function movements.f(line, cursor_pos, target_char)
	return line:find(target_char) - 1
end

function movements.t(line, cursor_pos, target_char)
	return movements.f(line, cursor_pos, target_char) - 1
end

function movements.F(line, cursor_pos, target_char)
	return line:find(target_char) - 1
end

function movements.T(line, cursor_pos, target_char)
	return movements.F(line, cursor_pos, target_char) + 1
end

local function move_word_start(line, cursor_pos, word_bound_func, counter)
	local word_positions = word_bound_func(line)
	local word_index = utility.calculate_word_index_from_cursor_pos(word_positions, cursor_pos)
	counter = counter - 1

	local cursor_is_at_word_start = cursor_pos == word_positions[word_index][1]
	if cursor_is_at_word_start then
		counter = counter + 1
	end
	local new_index = word_index - counter
	return word_positions[new_index][1]
end

function movements.word_start(line, cursor_pos, counter)
	return move_word_start(line, cursor_pos, utility.calculate_word_bounds, counter)
end

function movements.WORD_start(line, cursor_pos, counter)
	return move_word_start(line, cursor_pos, utility.calculate_WORD_bounds, counter)
end

return movements
