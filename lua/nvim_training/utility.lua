local utility = {}

function utility.replace_main_buffer_with_str(input_str)
	local str_as_lines = utility.split_str(input_str, "\n")
	-- Requires fix
	--vim.api.nvim_buf_set_lines(0, 0, 100, false,{})

	vim.api.nvim_buf_set_lines(0, 0, #str_as_lines, false, str_as_lines)
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

function utility.construct_path(file_suffix)
	--https://stackoverflow.com/questions/6380820/get-containing-path-of-lua-file
	function script_path()
		local str = debug.getinfo(2, "S").source:sub(2)
		local initial_result = str:match("(.*/)")
		return initial_result
	end

	local base_path = script_path() .. "../.."

	local file_path = base_path .. "/buffers/" .. file_suffix

	return file_path
end

return utility
