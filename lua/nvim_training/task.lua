-- luacheck: globals vim

local Task = {}
Task.__index = Task
Task.base_args = {
	instruction = "Generic Top Level Task Instruction",
	autocmds = {},
	tags = {},
	min_level = -1,
	help = "Generic Help",
	result = nil,
	description = "Generic Top Level Task Description",
}

-- This is the main object the whole code revolves around. A in-depth description is given in 'architecture.md' in the
-- docs folder
local utility = require("lua.nvim_training.utility")
function Task:new(custom_args)
	--This class not been adopted to the new style of 'new' that most other classes adhere to.
	local base = {}
	if not custom_args then
		custom_args = self.base_args
	end
	for i, v in pairs(self.base_args) do
		if not custom_args[i] then
			base[i] = v
		end
	end
	setmetatable(base, { __index = self })

	for i, v in pairs(custom_args) do
		base[i] = v
	end
	self.buffer_as_list = utility.construct_linked_list()
	return base
end

function Task:setup()
	print("Prepared from Baseclass called, please implement it in the subclass!")
end
function Task:apply_config()
	if vim.g.nvim_training.display_info then
		self.instruction = self.instruction .. self.help
	end
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

function Task:load_from_json(file_suffix)
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

	for i, v in pairs(data_from_json) do
		self[i] = v
	end
end

return Task
