-- luacheck: globals vim
local internal_config = require("nvim-training.internal_config")
local template_index = require("nvim-training.template_index")
local utility = {}
local templates = require("nvim-training.template_index")
function utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
	local lorem_ipsum = utility.lorem_ipsum_lines()
	utility.update_buffer_respecting_header(lorem_ipsum)
	utility.move_cursor_to_random_point()
end
function utility.create_highlight(x, y, len)
	--Todo: Improve by removing the unnecessary table
	local hl = {}
	hl.highlight_namespace = vim.api.nvim_create_namespace("DefaultNvimTrainingHlSpace")
	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })
	vim.api.nvim_buf_add_highlight(0, hl.highlight_namespace, "UnderScore", x, y, y + len)
	return hl
end

function utility.move_cursor_to_random_point()
	vim.api.nvim_win_set_cursor(0, utility.calculate_random_point_in_text_bounds())
end

function utility.calculate_random_point_in_text_bounds()
	local max_lines = vim.api.nvim_buf_line_count(0)

	local x = math.random(internal_config.header_length + 1, max_lines)

	local buffer_lines =
		vim.api.nvim_buf_get_lines(0, internal_config.header_length, vim.api.nvim_buf_line_count(0), false)
	local line_length = #buffer_lines[1]
	local y = math.random(0, line_length)
	return { x, y }
end

function utility.clear_highlight(highlight_obj)
	vim.api.nvim_buf_clear_namespace(0, highlight_obj.highlight_namespace, 0, -1)
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

local function construct_base_path()
	--https://stackoverflow.com/questions/6380820/get-containing-path-of-lua-file
	local function script_path()
		local str = debug.getinfo(2, "S").source:sub(2)
		local initial_result = str:match("(.*/)")
		return initial_result
	end

	local base_path = script_path() .. "../.."
	return base_path
end

function utility.construct_project_base_path(file_suffix)
	return construct_base_path() .. "/" .. file_suffix
end

function utility.lorem_ipsum_lines()
	local line_size = 70

	local line_array = {}
	for i = 1, #template_index.LoremIpsum, line_size do
		local current_text = string.sub(template_index.LoremIpsum, i, i + line_size)
		line_array[#line_array + 1] = current_text
	end
	local result = table.concat(line_array, "\n")
	return result
end

return utility
