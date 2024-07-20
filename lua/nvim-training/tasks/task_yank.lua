local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local TaskYank = {}
TaskYank.__index = TaskYank

setmetatable(TaskYank, { __index = Task })

TaskYank.__metadata = { autocmd = "", desc = "", instructions = "" }

function TaskYank:new()
	local base = Task:new()
	setmetatable(base, TaskYank)

	base.chosen_register = '"'
	return base
end
function TaskYank:deactivate(autocmd_callback_data)
	local register_content = vim.fn.getreg(self.chosen_register)
	register_content = utility.split_str(register_content, "\n")[1]
	print(self.target_text, register_content)
	return self.target_text == register_content
end

return TaskYank
