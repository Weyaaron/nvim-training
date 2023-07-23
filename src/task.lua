local cjson = require("cjson")

local Task = {}
Task.__index = Task

function Task:new()
	local base =
		{ desc = "Generic Top Level Task Description", autocmds = { "CursorMoved" }, minimal_level = 1, abr = "ABLT" }
	setmetatable(base, self)
	return base
end

function Task:prepare()
	print("Prepared from Baseclass called, please implement it in the subclass!")
end

function Task:completed()
	print("Completed from Baseclass called, please implement it in the subclass!")
	return false
end

function Task:failed()
	print("Failed from Baseclass called, please implement it in the subclass!")
	return false
end

function Task:teardown()
	print("Teardown from Baseclass called, please implement it in the subclass!")
end

function Task:load_from_json(file_path)
	local file = io.open(file_path)
	local content = file:read("a")
	local data_from_json = cjson.decode(content)

	file:close()

	local initial_buffer_file_path = "./buffer_files/" .. data_from_json.initial_buffer
	local new_buffer_file_path = "./buffer_files/" .. data_from_json.new_buffer

	file = io.open(initial_buffer_file_path)
	data_from_json.initial_buffer = file:read("a")
	file:close()
	file = io.open(new_buffer_file_path)
	data_from_json.new_buffer = file:read("a")
	file:close()

	for i, v in pairs(data_from_json) do
		self[i] = v
	end
end

return Task
