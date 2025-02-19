local utility = require("nvim-training.utility")
local setup_recipe_index = require("nvim-training.setup_recipe_index")

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
	print("got called in out text ", vim.inspect(base.metadata))
	if base.metadata.text_object then
		print("got called in task obj setup")
		setup_recipe_index[base.metadata.text_object.name](base, base.metadata.text_object)
	end
	return base
end

function Task:read_register()
	local register_content = vim.fn.getreg(self.target_register)
	return utility.split_str(register_content, "\n")[1]
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
