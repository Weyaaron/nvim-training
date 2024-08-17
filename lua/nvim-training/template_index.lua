local internal_config = require("nvim-training.internal_config")

function construct_base_path()
	--https://stackoverflow.com/questions/6380820/get-containing-path-of-lua-file
	local function script_path()
		local str = debug.getinfo(2, "S").source:sub(2)
		local initial_result = str:match("(.*/)")
		return initial_result
	end

	local base_path = script_path() .. "../.."
	return base_path
end
local function load_template_from_file(file_path)
	local act_path = construct_base_path() .. "/" .. file_path
	local file = io.open(act_path)
	local content = file:read("a")
	file:close()
	return content
end

local function construct_rectangular_template()
	local result = ""

	for i = 1, internal_config.line_length do
		result = result .. "-"
	end
	result = result .. "\n"

	for i = 1, internal_config.line_length do
		result = result .. "-"
	end
	return result
end

local templates = {
	LoremIpsum = load_template_from_file("./templates/lorem_ipsum.txt"),
	Rectangle = construct_rectangular_template(),
	LoremIpsumWORDS = load_template_from_file("./templates/lorem_ipsum_WORDS.txt"),
	-- LoremIpsum = "",
	LuaFunctions = load_template_from_file("./templates/lua_functions.txt"),
	-- LuaFunctions = "",
}

return templates
