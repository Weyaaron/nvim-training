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
	if not sep then
		sep = "\n"
	end
	if not input then
		return {}
	end

	local lines = {}
	for line in string.gmatch(input, "(.-)" .. sep) do
		table.insert(lines, line)
	end
	return lines
end

return utility
