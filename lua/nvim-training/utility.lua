-- luacheck: globals vim
local Word = require("nvim-training.word")

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

function utility.clear_highlight(highlight_obj)
	vim.api.nvim_buf_clear_namespace(0, highlight_obj.highlight_namespace, 0, -1)
end

function utility.update_buffer_respecting_header(input_str)
	local str_as_lines = utility.split_str(input_str, "\n")
	local function basic_update()
		vim.api.nvim_buf_set_lines(0, config.header_length, config.buffer_length, false, {})

		local end_index = config.header_length + #str_as_lines
		vim.api.nvim_buf_set_lines(0, config.header_length, end_index, false, str_as_lines)
	end

	vim.schedule_wrap(basic_update)()
end

function utility.construct_random_word_from_text(input_text)
	local text_as_lines = utility.split_str(input_text, "\n")
	local line_index = math.random(#text_as_lines)
	local line_as_words = utility.split_str(text_as_lines[line_index], " ")
	local word_index = math.random(#line_as_words)
	local actual_word = line_as_words[word_index]

	local start_index_in_line = string.find(text_as_lines[line_index], actual_word)
	local result =
		Word:new({ content = actual_word, line_index = word_index, x_pos = line_index, y_pos = start_index_in_line })
	return result
end

function utility.traverse_text_n_words_forward(input_text, start_word, n)
	local text_as_lines = utility.split_str(input_text, "\n")
	local line = text_as_lines[start_word.line_index]
	-- local attempt_to_traverse_same_line = line[start_word.
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

function utility.lorem_ipsum_lines(line_length)
	if not line_length then
		line_length = 3
	end
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
