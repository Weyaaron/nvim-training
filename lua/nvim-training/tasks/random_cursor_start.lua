local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
--Todo: Work through remaing tasks and apply
local RandomCursorStart = {}

setmetatable(RandomCursorStart, { __index = Task })
RandomCursorStart.__index = RandomCursorStart

function RandomCursorStart:new()
	local base = Task:new()
	setmetatable(base, { __index = RandomCursorStart })
	return base
end

function RandomCursorStart:activate()
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
	end
	vim.schedule_wrap(_inner_update)()
end

return RandomCursorStart
