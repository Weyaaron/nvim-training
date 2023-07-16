local cjson = require("cjson")

local utility = {}

function utility.replace_main_buffer_with_str(input_str)
	local str_as_lines = utility.split_str(input_str, "\n")
	-- Requires fix
	--vim.api.nvim_buf_set_lines(0, 0, 100, false,{})

	vim.api.nvim_buf_set_lines(0, 0, #str_as_lines, false, str_as_lines)
end

function utility.read_buffer_source_file(file_path)
	local file = io.open(file_path)
	local content = file:read("a")
	local data_from_json = cjson.decode(content)
	file:close()

	local initial_buffer_file_path = "./buffer_files/" .. data_from_json["initial_buffer"]
	local new_buffer_file_path = "./buffer_files/" .. data_from_json["new_buffer"]

	file = io.open(initial_buffer_file_path)
	data_from_json["initial_buffer"] = file:read("a")
	file:close()
	file = io.open(new_buffer_file_path)
	data_from_json["new_buffer"] = file:read("a")
	file:close()

	return data_from_json
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
		return { input}
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

return utility
