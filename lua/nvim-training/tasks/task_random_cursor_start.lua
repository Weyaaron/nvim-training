local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
--Todo: Work through remaing tasks and apply
local TaskRandomCursorStart = {}

setmetatable(TaskRandomCursorStart, { __index = Task })
TaskRandomCursorStart.__index = TaskRandomCursorStart

function TaskRandomCursorStart:new()
	local base = Task:new()
	setmetatable(base, { __index = TaskRandomCursorStart })
	return base
end

function TaskRandomCursorStart:activate()
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
	end
	vim.schedule_wrap(_inner_update)()
end

return TaskRandomCursorStart
