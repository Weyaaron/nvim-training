local utility = {}

local logging = require("lua.nvim_training.log")
logging.outfile = "./logs/utility.log"

function utility.replace_main_buffer_with_str(input_str)
	local line_count = vim.api.nvim_buf_line_count(0)
	local current_buffer_lines = vim.api.nvim_buf_get_lines(0, 0, line_count, false)

	local str_as_lines = utility.split_str(input_str, "\n")
	local buffer_equality = true

	for i, v in pairs(current_buffer_lines) do
		buffer_equality = buffer_equality and (v == str_as_lines[i])
	end
	logging.info("The buffers are " .. tostring(buffer_equality))
	if not buffer_equality then
		vim.api.nvim_buf_set_lines(0, 0, line_count, false, {})
		vim.api.nvim_buf_set_lines(0, 0, #str_as_lines, false, str_as_lines)
	end
end

function utility.split_str(input, sep)
	if not input then
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

function utility.draw_random_number_with_sign(lower_bound, upper_bound)
	local initial_value = math.random(lower_bound, upper_bound)
	local multiplier = { 1, -1 }
	return initial_value * multiplier[math.random(1, 2)]
end

function utility.intersection(a, b)
	local result = {}
	for _, a_el in pairs(a) do
		for _, b_el in pairs(b) do
			if a_el == b_el then
				table.insert(result, a_el)
			end
		end
	end

	return result
end
function construct_base_path()
	--https://stackoverflow.com/questions/6380820/get-containing-path-of-lua-file
	function script_path()
		local str = debug.getinfo(2, "S").source:sub(2)
		local initial_result = str:match("(.*/)")
		return initial_result
	end

	local base_path = script_path() .. "../.."
	return base_path
end

function utility.construct_buffer_path(file_suffix)
	return construct_base_path() .. "/buffers/" .. file_suffix
end

function utility.construct_project_base_path(file_suffix)
	return construct_base_path() .. "/" .. file_suffix
end

return utility
