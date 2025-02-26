local utility = require("nvim-training.utility")

local interface_names =
	{ "counter", "target_char", "name", "target_register", "input_template", "search_target", "target_quote" }

local Task = {}
Task.__index = Task
Task.metadata = {}

function Task:new()
	local base = {}
	setmetatable(base, Task)
	--This is usefull for such a huge swath of tasks that this is worthwile
	base.counter = utility.calculate_counter()

	base.cursor_target = { 0, 0 }
	base.target_char = utility.calculate_target_char()
	base.cursor_center_pos = utility.calculate_center_cursor_pos()
	base.file_type = "txt"

	base.target_register = utility.calculate_target_register()
	vim.fn.setreg(base.target_register, "")
	return base
end

function Task:read_register()
	local register_content = vim.fn.getreg(self.target_register)
	return utility.split_str(register_content, "\n")[1]
end

function Task:construct_interface_data()
	local result = {}
	for i, v in pairs(interface_names) do
		result[v] = self.metadata[v] or self[v]
	end
	return result
end

function Task:activate() end

function Task:deactivate(autocmd_callback_data) end

function Task:instructions()
	return self.metadata.instructions
end

function Task:construct_optional_header_args()
	--This might someday be merged with description, but remains a special case for the time being.
	return {}
end

return Task
