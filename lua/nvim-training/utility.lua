local internal_config = require("nvim-training.internal_config")
local template_index = require("nvim-training.template_index")
local utility = {}

function utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
	local lorem_ipsum = utility.lorem_ipsum_lines()
	utility.update_buffer_respecting_header(lorem_ipsum)
	utility.move_cursor_to_random_point()
end

function utility.add_pair_and_place_cursor(bracket_pair)
	local lorem_ipsum = utility.lorem_ipsum_lines()
	utility.update_buffer_respecting_header(lorem_ipsum)

	utility.move_cursor_to_random_point()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(cursor_pos[1] - 1)
	local distance = 5
	local start_of_line = string.sub(line, 0, cursor_pos[2])
	local middle_piece = string.sub(line, cursor_pos[2], cursor_pos[2] + distance)
	local end_piece = string.sub(line, cursor_pos[2] + distance, #line)

	local new_line = start_of_line .. bracket_pair[1] .. middle_piece .. bracket_pair[2] .. end_piece

	vim.api.nvim_buf_set_lines(0, cursor_pos[1] - 1, cursor_pos[1], false, { new_line })

	utility.create_highlight(cursor_pos[1] - 1, cursor_pos[2], distance + 2)

	if math.random(0, 2) == 0 then
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_pos[2] + distance + 2 })
	end
end

function utility.extract_text_in_brackets(text, bracket_pair) --This includes the brackets!
	local start_index = 0
	local end_index = 0
	for i = 1, #text, 1 do
		if text:sub(i, i) == bracket_pair[1] then
			start_index = i
		end

		if text:sub(i, i) == bracket_pair[2] then
			end_index = i
		end
	end
	return text:sub(start_index, end_index)
end

function utility.create_highlight(x, y, len)
	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })
	vim.api.nvim_buf_add_highlight(0, internal_config.global_hl_namespace, "UnderScore", x, y, y + len)
end

function utility.move_cursor_to_random_point()
	vim.api.nvim_win_set_cursor(0, utility.calculate_random_point_in_text_bounds())
end

function utility.select_random_word_bounds_at_line(i)
	local line = utility.get_line(i)
	local word_params = utility.calculate_word_bounds(line)
	return word_params[math.random(1, #word_params)]
end

function utility.calculate_random_point_in_text_bounds()
	local x = utility.random_line_index()
	local y = utility.random_col_index_at(x)
	return { x, y }
end

function utility.get_word_bounds(s) -- { start_index, length }
	local words = {}
	-- words as consequent groups of alphanumeric chars with underline '_'
	for start, _, finish in s:gmatch("()([%w_]+)()") do
		words[#words + 1] = { start, finish - start }
	end
	return words
end

function utility.random_line_index()
	local line_count = vim.api.nvim_buf_line_count(0)
	return math.random(internal_config.header_length + 1, line_count - 1)
end

function utility.get_line(index)
	return vim.api.nvim_buf_get_lines(0, index, index + 1, true)[1]
end

function utility.random_col_index_at(index)
	return math.random(0, #utility.get_line(index))
end

function utility.clear_all_our_highlights()
	vim.api.nvim_buf_clear_namespace(0, internal_config.global_hl_namespace, 0, -1)
end

function utility.update_buffer_respecting_header(input_str)
	local str_as_lines = utility.split_str(input_str, "\n")
	vim.api.nvim_buf_set_lines(0, internal_config.header_length, internal_config.buffer_length, false, {})

	local end_index = internal_config.header_length + #str_as_lines
	vim.api.nvim_buf_set_lines(0, internal_config.header_length, end_index, false, str_as_lines)
end

function utility.split_str(input, sep)
	if not input then
		print("No input")
		return {}
	end
	if not sep then
		sep = "\n"
	end

	assert(type(input) == "string" and type(sep) == "string", "The arguments must be <string>")
	if sep == "" then
		return { input }
	end

	local res, from = {}, 1
	repeat
		local pos = input:find(sep, from)
		res[#res + 1] = input:sub(from, pos and pos - 1)
		from = pos and pos + #sep
	until not from
	if #res == 0 then
		return { input }
	end
	return res
end

function utility.lorem_ipsum_lines()
	local line_size = 70

	local line_array = {}

	local lorem_ipsum_as_line = string.gsub(template_index.LoremIpsum, "\n", " ")
	for i = 1, #lorem_ipsum_as_line, line_size do
		local current_text = string.sub(lorem_ipsum_as_line, i, i + line_size)
		line_array[#line_array + 1] = current_text
	end
	return table.concat(line_array, "\n")
end

return utility
