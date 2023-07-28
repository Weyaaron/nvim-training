local Task = {}
Task.__index = Task
Task.base_args = { desc = "Generic Top Level Task Description", autocmds = { "CursorMoved" }, abr = "ABLT", tags = {} }

local utility = require("nvim_training.utility")
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
	local file_path = utility.construct_buffer_path(file_suffix)

	local file = io.open(file_path)
	local content = file:read("a")
	local data_from_json = vim.json.decode(content)

	file:close()

	local initial_buffer_file_path = utility.construct_buffer_path(data_from_json.initial_buffer)
	local new_buffer_file_path = utility.construct_buffer_path(data_from_json.new_buffer)

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

function Task:calculate_task_chain()
	--This function implements task chaining by traversing the line of tasks until the first one has no
	--precondition. While task chains of arbitrary length are supported, task chains should be short in practice.
	local task_chain = {}
	local current_task = self:previous()
	local last_chain_el = self
	while current_task do
		last_chain_el = current_task
		current_task = current_task:previous()
	end
	current_task = last_chain_el
	while current_task do
		table.insert(task_chain, current_task)
		current_task = current_task:next()
	end
	return task_chain
end

function Task:previous()
	--This function implements task chaining. The Task Scheduler will ensure that a task
	--that is required runs first. This does support tasks chains of arbitrary length.

	return nil
end
function Task:next()
	--This function implements task chaining.Some tasks profit from context. The Task Scheduler will ensure that a
	--the returned task runs next. This supports tasks chains of arbitrary length.

	return nil
end

return Task
