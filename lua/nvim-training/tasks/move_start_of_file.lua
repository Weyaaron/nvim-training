local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

local MoveToStartOfFile = Task:new()
MoveToStartOfFile.__index = MoveToStartOfFile

function MoveToStartOfFile:new()
	local base = Task:new()

	setmetatable(base, { __index = MoveToStartOfFile })
	self.autocmd = "CursorMoved"
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
	end
	vim.schedule_wrap(_inner_update)()
	return self
end

function MoveToStartOfFile:teardown(autocmd_callback_data)
	return vim.api.nvim_win_get_cursor(0)[1] == 1
end

function MoveToStartOfFile:description()
	return "Move to the top of the file."
end

return MoveToStartOfFile
