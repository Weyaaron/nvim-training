local Task = {}
Task.__index = Task
Task.base_args = { desc = "Generic Top Level Task Description", autocmds = { "CursorMoved" }, abr = "ABLT", tags = {} }

function Task:new(custom_args)
	self.__index = self
	local base = {}
	if not custom_args then
		custom_args = self.base_args
	end
	for i, v in pairs(self.base_args) do
		if not custom_args[i] then
			base[i] = v
		end
	end
	setmetatable(base, self)

	for i, v in pairs(custom_args) do
		base[i] = v
	end
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

function Task:load_from_json(file_suffix, minimal_keys)
	if not minimal_keys then
		minimal_keys = {}
	end

	local full_path = "./buffers/" .. file_suffix

	local file = io.open(full_path)
	local content = file:read("a")
	local data_from_json = vim.json.decode(content)

	file:close()

	local initial_buffer_file_path = "./buffers/" .. data_from_json.initial_buffer
	local new_buffer_file_path = "./buffers/" .. data_from_json.new_buffer

	file = io.open(initial_buffer_file_path)
	data_from_json.initial_buffer = file:read("a")
	file:close()
	file = io.open(new_buffer_file_path)
	data_from_json.new_buffer = file:read("a")
	file:close()

	for key, el in pairs(minimal_keys) do
		if not data_from_json[key] then
			print("Json is missing minimal key:" .. tostring(el))
		end
	end

	for i, v in pairs(data_from_json) do
		self[i] = v
	end
end

function Task:first()
	return nil
end
function Task:next()
	return nil
end

return Task
