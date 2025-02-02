local utility = require("nvim-training.utility")
local user_config = require("nvim-training.user_config")
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

	base.choosen_reg = user_config.possible_register_list[math.random(#user_config.possible_register_list)]
	return base
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
