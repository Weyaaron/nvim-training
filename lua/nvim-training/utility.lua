-- luacheck: globals vim
local Word = require("nvim-training.word")
local current_config = require("nvim-training.current_config")

local utility = {}

local config = require("nvim-training.current_config")

function utility.create_highlight(x, y, len)
	local hl = {}
	local highlight_namespace = vim.api.nvim_create_namespace("DefaultNvimTrainingHlSpace")
	hl.highlight_namespace = highlight_namespace
	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })
	vim.api.nvim_buf_add_highlight(0, highlight_namespace, "UnderScore", x, y, y + len)
	return hl
end

function utility.move_cursor_to_random_point()
	vim.api.nvim_win_set_cursor(0, utility.calculate_random_point_in_text_bounds())
end

function utility.calculate_random_point_in_text_bounds()
	local max_lines = vim.api.nvim_buf_line_count(0)

	local x = math.random(current_config.header_length, max_lines)

	local buffer_lines = vim.api.nvim_buf_get_lines(0, config.header_length, vim.api.nvim_buf_line_count(0), false)
	local line_length = #buffer_lines[1]
	local y = math.random(0, line_length)
	return { x, y }
end

function utility.clear_highlight(highlight_obj)
	vim.api.nvim_buf_clear_namespace(0, highlight_obj.highlight_namespace, 0, -1)
end

function utility.update_buffer_respecting_header(input_str)
	local str_as_lines = utility.split_str(input_str, "\n")
	vim.api.nvim_buf_set_lines(0, config.header_length, config.buffer_length, false, {})

	local end_index = config.header_length + #str_as_lines
	vim.api.nvim_buf_set_lines(0, config.header_length, end_index, false, str_as_lines)
end

function utility.place_exmark_on_random_word()
	local buffer_text = vim.api.nvim_buf_get_lines(0, config.header_length, vim.api.nvim_buf_line_count(0), false)
	local x_y = utility.extract_x_y_for_random_word(table.concat(buffer_text, "\n"))
	local target_exmark = vim.api.nvim_buf_set_extmark(0, current_config.exmark_name_space, x_y[1], x_y[2], {})
	return target_exmark
end

function utility.extract_x_y_for_random_word(input_text)
	local text_as_lines = utility.split_str(input_text, "\n")
	local line_index = math.random(#text_as_lines - 1)
	local line_as_words = utility.split_str(text_as_lines[line_index], " ")
	-- local word_index = math.random(#line_as_words - 1)
	-- local word_index = math.random(#line_as_words - 1)
	-- Todo: Fix an error about broken exmark placement
	local word_index = 5
	local actual_word = line_as_words[word_index]
	local start_index_in_line = string.find(text_as_lines[line_index], actual_word)
	-- print(actual_word, line_index + current_config.header_length, start_index_in_line - 1)
	return { line_index + current_config.header_length, start_index_in_line - 1 }
end

function utility.calculate_line_offset_for_word(words, target_word)
	local resulting_length = 0
	for i = 1, #words, 1 do
		local table_sclice = table.unpack(words, 1, i)
		local full_string = table.concat(table_sclice, "")
		resulting_length = #full_string
	end
	return resulting_length
end

function utility.traverse_text_n_words_forward_and_construct_exmark(initial_ex_mark, n)
	local x_y = vim.api.nvim_buf_get_extmark_by_id(0, current_config.exmark_name_space, initial_ex_mark, {})

	local lines = vim.api.nvim_buf_get_lines(0, x_y[1] - 1, vim.api.nvim_buf_line_count(0), false)

	local text_right_of_exmark = string.sub(lines[1], x_y[2], #lines[1])
	local words_in_line_right_of_exmark = utility.split_str(text_right_of_exmark, " ")

	local lines_for_search = { text_right_of_exmark, unpack(lines) }
	local line_counter = 1
	local words_remaining = n
	while words_remaining > 0 do
		words_remaining = words_remaining - #utility.split_str(lines_for_search[line_counter])
		line_counter = line_counter + 1
	end

	words_remaining = words_remaining + #utility.split_str(lines_for_search[line_counter - 1])
	local line_for_word_search = lines_for_search[line_counter]
	local final_y_index = 0
	for i = 1, #line_for_word_search do
		local current_char = string.sub(line_for_word_search, i, i)
		if current_char == " " then
			words_remaining = words_remaining - 1
		end
		if words_remaining == 0 then
			final_y_index = i
		end
	end
	print("Y found at " .. final_y_index, "searching in line" .. line_counter)

	-- local target_exmark = vim.api.nvim_buf_set_extmark(0, current_config.exmark_name_space, x_y[1], x_y[2], {})

	local highlight = utility.create_highlight(final_y_index - 1, current_config.header_length + line_counter, 3)

	--Do this accross lines?
	local full_string = table.concat(lines, "\n")
	local traversed_words = 0
	local new_x = 0
	local new_y = 0

	for i = x_y[2], #full_string - 1, 1 do
		local current_char = string.sub(full_string, i, i)
		if current_char == " " then
			traversed_words = traversed_words + 1
		end
		if traversed_words == n then
			new_y = i
			break
		end
		-- print(current_char)
	end
end

function utility.calculate_index_in_text_from_word() end
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
	local basic_text =
		"Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

	local line_array = {}
	for i = 1, #basic_text, line_size do
		local current_text = string.sub(basic_text, i, i + line_size)
		line_array[#line_array + 1] = current_text
	end
	local result = table.concat(line_array, "\n")
	return result
end

return utility
