local cjson = require("cjson")

local utility = {}

function utility.replace_main_buffer_with_str(input_str)
	local str_as_lines = utility.split_str(input_str, "\n")
	-- Requires fix
	--vim.api.nvim_buf_set_lines(0, 0, 100, false,{})

	vim.api.nvim_buf_set_lines(0, 0, #str_as_lines, true, str_as_lines)
end

function utility.read_buffer_source_file(file_path)
	local file = io.open(file_path)
	local content = file:read("a")
	local value = cjson.decode(content)
	return value
end

function utility.split_str(input, sep)
	if not sep then
		sep = "\n"
	end

	local t = {}
	for str in string.gmatch(input, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

return utility
