-- luacheck: globals vim

local Task = require("nvim_training.task")

local BaseMovementTask = Task:new()
local utility = require("nvim_training.utility")

BaseMovementTask.base_args = {}

function BaseMovementTask:completed()
	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local x_diff = current_cursor[1] - self.new_buffer_coordinates[1]
	local y_diff = current_cursor[2] - self.new_buffer_coordinates[2]
	return x_diff == 0 and y_diff == 0
end

function BaseMovementTask:failed()
	return not self:completed()
end

function BaseMovementTask:teardown()
	utility.clear_highlight(self.highlight)
end

return BaseMovementTask
