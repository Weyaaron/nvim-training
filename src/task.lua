local cjson = require("cjson")

local Task = {}

function Task:new()
	local newObj = { desc = nil, autocmds = { "CursorMoved" }, minimal_level = 1, abr = "ABLT" }
	self.__index = self
	setmetatable(newObj, self)
	return newObj
end

function Task:completed()
	return false
end

function Task:failed()
	return false
end

function Task:teardown() end

function Task:load_from_json(file_path)
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

	for _,v in ipairs(data_from_json) do
		table.insert(self, v)
	end

end

return Task
