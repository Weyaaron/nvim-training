local internal_config = require("nvim-training.internal_config")
local template_index = require("nvim-training.template_index")
local utility = {}

function utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
	utility.update_buffer_respecting_header(utility.load_template(template_index.LoremIpsum))
	utility.move_cursor_to_random_point()
end

function utility.get_keys(t)
	local keys = {}
	for key, _ in pairs(t) do
		table.insert(keys, key)
	end
	return keys
end

function utility.add_pair_and_place_cursor(bracket_pair)
	local lorem_ipsum = utility.load_template(template_index.LoremIpsum)
	utility.update_buffer_respecting_header(lorem_ipsum)

	utility.move_cursor_to_random_point()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(cursor_pos[1])
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

function calculate_text_piece_bounds(input_str, patterns) -- { start_index, end_index}, 0-indexed
	local pieces = {}

	for i, pattern_el in pairs(patterns) do
		for start, _, finish in input_str:gmatch(pattern_el) do
			pieces[#pieces + 1] = { start - 1, finish - 1 }
		end
	end

	table.sort(pieces, function(a, b)
		return a[1] < b[1]
	end)

	return pieces
end

function utility.calculate_WORD_bounds(input_str) -- { start_index, end_index}, 0-indexed
	--Defined as non-whitespace characters surrounded by whitespace
	local match_strs = { "()%s*(%S+)%s*()" }
	return calculate_text_piece_bounds(input_str, match_strs)
end

function utility.calculate_word_bounds(s) -- { start_index, end_index}, 0-indexed
	-- words as consequent groups of alphanumeric chars with underline '_', the second matches match . and , respectivly
	local match_strs = { "()([%w_]+)()", "()(%.)()", "()(,)()" }
	return calculate_text_piece_bounds(s, match_strs)
end

function utility.calculate_word_index_from_cursor_pos(word_bounds, cursor_pos)
	local index = 0
	for i, v in pairs(word_bounds) do
		local word_start = v[1]
		local word_end = v[2]
		if cursor_pos <= word_end and cursor_pos >= word_start then
			index = i
		end
	end
	return index
end

function utility.random_line_index()
	local line_count = vim.api.nvim_buf_line_count(0)
	return math.random(internal_config.header_length + 1, line_count - 1)
end

function utility.get_line(index)
	return vim.api.nvim_buf_get_lines(0, index - 1, index, true)[1]
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

function utility.load_template(template_path)
	local lines = {}

	local template_as_line = string.gsub(template_path, "\n", " ")
	for i = 1, #template_as_line, internal_config.line_length do
		local current_text = string.sub(template_as_line, i, i + internal_config.line_length)
		lines[#lines + 1] = current_text
	end
	return table.concat(lines, "\n")
end

return utility
