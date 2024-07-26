local Task = require("nvim-training.task")
local TaskMove = {}
TaskMove.__index = TaskMove
setmetatable(TaskMove, { __index = Task })
TaskMove.__metadata = { autocmd = "", desc = "", instructions = "" }

function TaskMove:new()
	local base = Task:new()
	setmetatable(base, TaskMove)

	self.cursor_target = { 0, 0 }
	return base
end
function TaskMove:deactivate(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	if type(self.cursor_target) == "number" then
		print("Target has to be type table, current value is " .. tostring(self.cursor_target))
	end
	print(vim.inspect(cursor_pos), vim.inspect(self.cursor_target))
	return cursor_pos[1] == self.cursor_target[1] and cursor_pos[2] == self.cursor_target[2]
end

return TaskMove
